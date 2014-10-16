################################################################################
# VIEWS
################################################################################
class DeloitteGame.Views.GameCardsCollection extends Backbone.View
  el: '.cards-container'
  initialize: ->
    @render()

  render: =>
    @collection.each @renderCard, @

  renderCard: (card)=>
    $card = @$(".game-card-container#game-card-#{card.get('id')}")
    cardView = new DeloitteGame.Views.GameCard({el: $card, model: card})

class DeloitteGame.Views.GameCard extends Backbone.View
  events:
    'click .select-color': 'colorClicked'
    'click .card-flipper': 'flipCard'
    'click .starred-circle': 'starCard'
  initialize: ->
    @model.on 'change:color change:starred', @render
    @render()

  render: =>
    @clearClasses()
    @$el.addClass @model.get('color')
    @$el.addClass('color-choosed') if @model.get('pile')
    @$el.addClass('cor-adj-color') if @model.get('pile') is 'adjacent' or (@model.get('pile') is 'core' and !@model.get('starred'))
    @$(".select-color.#{@model.get('color')}").addClass 'selected'
    @$el.addClass 'starred' if @model.get('starred')

  starCard: =>
    if @$el.hasClass('cor-adj-color') and !@$el.hasClass('green-color') and @$el.closest('.cards-container.adjacent').length > 0
      @$el.find('.select-color.green-color').click()
    @model.toggleStarred()
    DeloitteGame.EventDispatcher.trigger 'card:colorclicked', @model

  clearClasses: =>
    @$el.removeClass 'cor-adj-color blue-color purple-color orange-color green-color no-color color-choosed starred'
    @$('.select-color').removeClass 'selected'

  colorClicked: (e)=>
    @model.updatePile $(e.currentTarget).data('pile')
    DeloitteGame.EventDispatcher.trigger 'card:colorclicked'

  flipCard: (e)=>
    @$el.find('.game-card').toggleClass 'flipped'
    false

class DeloitteGame.Views.GameState extends Backbone.View
  initialize: ->
    @model.on 'change:visibleCards', @sortCards
    DeloitteGame.EventDispatcher.on 'game:reset', @resetGame
    filter = DeloitteGame.Helpers.getColorClassFromView(Backbone.history.fragment)
    if filter is 'all' then filter = @model.get('visibleCards')
    @$el.mixItUp
        animation:
          duration: 940
          effects: 'fade translateZ(-360px) rotateY(-100deg) stagger(20ms)'
          easing: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
        selectors:
          target: '.game-card-container'
        load:
          filter: filter

  sortCards: =>
    @$el.removeClass 'game core adjacent aspirational out-of-bounds'
    @$el.addClass @model.get 'currentView'
    if @model.get('cssTransitions')
      @$el.mixItUp 'filter', @model.get('visibleCards')
    else
      @$el.delay(800).fadeOut =>
        @$el.mixItUp 'filter', @model.get('visibleCards')
        @$el.fadeIn()
        jQuery('html,body', document).animate({scrollTop:340}, 300)


  resetGame: =>
    localStorage.clear()
    location.reload()

# RESPONSIBLE FOR PILES CONTAINER INTERACTIONS LIKE STICKING
# TO TOP AND OPENING DESCRIPTIONS WHEN IN SMALL SCREENS
class DeloitteGame.Views.PilesContainer extends Backbone.View
  template: null
  events:
    'click .cards-pile': 'cardsPileClicked'
  initialize: ->
    DeloitteGame.EventDispatcher.on 'window:stucktoggle', @toggleStuck
    DeloitteGame.EventDispatcher.on 'view:changed', @closeFloatingPile
    @template = Handlebars.compile($('#pile-description').html())
    @$el.append('<div id="floating-pile-description">')
    @floatingPileDescrition = @$('#floating-pile-description')
    @model.on 'change', @render

  render: =>
    @clearClasses()
    if @model.get('pile')
      $target = @$(".cards-pile[data-pile~=#{@model.get('pile')}]")
      $target.addClass 'open-pile'
      @floatingPileDescrition.addClass("open #{@model.get('pile')}")
      @floatingPileDescrition.html(@template(@model.toJSON()))

  cardsPileClicked: (e)=>
    @model.updatePile $(e.currentTarget).data('pile')
    @model.set 'description', $(e.currentTarget).find('.pile-description').html()
    @model.set 'title', $(e.currentTarget).find('.full-title').html()

  clearClasses: =>
    @$('.cards-pile').removeClass 'open-pile'
    @floatingPileDescrition.removeClass 'open core adjacent out-of-bounds aspirational'

  toggleStuck: =>
    @$el.parent().toggleClass('stuck')

  closeFloatingPile: =>
    @floatingPileDescrition.removeClass 'open'
    @$('.cards-pile').removeClass 'open-pile'

# RESPONSIBLE TO CHANGE FOOTER COUNTER WHEN A NEW CARD IS SELECTED
class DeloitteGame.Views.FooterCounter extends Backbone.View
  tagName: 'span'
  template: null
  events:
    'click .cards-left-bt': 'singleCard'
    'click .cards-all-bt': 'allCards'
    'click .clear-cards-bt': 'clearCards'

  initialize: ->
    @model.on 'change', @render
    @template = Handlebars.compile($('#cards-counter').html())
    @render()

  render: =>
    @$el.html @template(@model.toJSON())
    new DeloitteGame.Views.MenuTogglr({el: @$('.navbar-toggle')})

  singleCard: (e)=>
    @model.set('isSingleCard', true)
    @model.checkVisibleCards()
    false

  allCards: (e)=>
    @model.set('isSingleCard', false)
    DeloitteGame.EventDispatcher.trigger 'visiblecards:changed', 'all'
    false

  clearCards: (e)=>
    confirmation = confirm "Are you sure you want to clear all your card selections and START OVER AGAIN?"
    DeloitteGame.EventDispatcher.trigger 'game:reset' if confirmation
    false

class DeloitteGame.Views.FooterNav extends Backbone.View
  template: null
  events:
    'click .clear-cards-bt': 'clearCards'

  initialize: ->
    @model.on 'change', @render
    @template = Handlebars.compile($("#footer-nav-next").html())
    @render()

  render: =>
    @$el.html @template(@model.toJSON())

  clearCards: (e)=>
    e.preventDefault()
    confirmation = confirm "Are you sure you want to clear all your card selections and START OVER AGAIN?"
    DeloitteGame.EventDispatcher.trigger 'game:reset' if confirmation

class DeloitteGame.Views.PageArrowNav extends Backbone.View
  tagName: 'aside'
  template: null
  events:
    'click': 'checkIfCanNavigate'

  initialize: ->
    @model.on 'change', @render
    @template = Handlebars.compile($("##{@$el.data('direction')}-arrow-template").html())
    @render()

  render: =>
    @$el.html @template(@model.toJSON())

  checkIfCanNavigate: =>
    unless @$('a').hasClass 'can-navigate'
      return false
    else
      jQuery('html,body', document).animate({scrollTop:100}, 300)

class DeloitteGame.Views.WindowControll extends Backbone.View
  events:
    'scroll': 'updatedScrollPos'

  initialize: ->
    $('.change-page').on 'click', @saveBeforeLeave
    @model.on 'change', @render
    @topBarStuck = false
    @topBarPosition = $('#sticky-wrapper').offset().top
    @render()

  render: =>
    $('body').removeClass 'game core adjacent aspirational out-of-bounds'
    $('body').addClass @model.get('currentView')
    @topBarPosition = $('#sticky-wrapper').offset().top

  updatedScrollPos: =>
    top = @$el.scrollTop()
    if top >= @topBarPosition and !@topBarStuck
      @topBarStuck = true
      DeloitteGame.EventDispatcher.trigger 'window:stucktoggle'
    else if top <= @topBarPosition and @topBarStuck
      @topBarStuck = false
      DeloitteGame.EventDispatcher.trigger 'window:stucktoggle'

  saveBeforeLeave: (e)=>
    link = $(e.currentTarget).find('a').attr('href')
    unless link.indexOf('#') > -1
      DeloitteGame.EventDispatcher.trigger 'collection:persist'
      setTimeout ->
        window.location.href = link
      , 3000
      false