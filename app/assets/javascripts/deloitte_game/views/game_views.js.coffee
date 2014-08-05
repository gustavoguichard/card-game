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
    @$(".select-color.#{@model.get('color')}").addClass 'selected'
    @$el.addClass 'starred' if @model.get('starred')

  starCard: =>
    @model.toggleStarred()
    DeloitteGame.EventDispatcher.trigger 'card:colorclicked', @model

  clearClasses: =>
    @$el.removeClass 'blue-color purple-color orange-color green-color no-color color-choosed starred'
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
    filter = DeloitteGame.Helpers.getColorClassFromView(Backbone.history.fragment)
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
    @$el.mixItUp 'filter', @model.get('visibleCards')

# RESPONSIBLE FOR PILES CONTAINER INTERACTIONS LIKE STICKING
# TO TOP AND OPENING DESCRIPTIONS WHEN IN SMALL SCREENS
class DeloitteGame.Views.PilesContainer extends Backbone.View
  events:
    'click .cards-pile': 'cardsPileClicked'
  initialize: ->
    DeloitteGame.EventDispatcher.on 'window:stucktoggle', @toggleStuck
    @$el.append('<div id="floating-pile-description">')
    @floatingPileDescrition = @$('#floating-pile-description')
    @model.on 'change', @render

  render: =>
    @clearClasses()
    if @model.get('pile')
      $target = @$(".cards-pile[data-pile~=#{@model.get('pile')}]")
      $target.addClass 'open-pile'
      @floatingPileDescrition.addClass("open #{@model.get('pile')}")
      @floatingPileDescrition.html(@model.get 'description')

  cardsPileClicked: (e)=>
    @model.updatePile $(e.currentTarget).data('pile')
    @model.set 'description', $(e.currentTarget).find('.pile-description').html()

  clearClasses: =>
    @$('.cards-pile').removeClass 'open-pile'
    @floatingPileDescrition.removeClass 'open core adjacent out-of-bounds aspirational'

  toggleStuck: =>
    @$el.parent().toggleClass('stuck')

# RESPONSIBLE TO CHANGE FOOTER COUNTER WHEN A NEW CARD IS SELECTED
class DeloitteGame.Views.FooterCounter extends Backbone.View
  tagName: 'span'
  template: Handlebars.compile($('#cards-counter').html())
  events:
    'click .cards-left-bt': 'leftCards'
    'click .cards-all-bt': 'allCards'

  initialize: ->
    @model.on 'change', @render
    @render()

  render: =>
    @$el.html @template(@model.toJSON())

  leftCards: (e)=>
    DeloitteGame.EventDispatcher.trigger 'visiblecards:changed', '.no-color'
    false

  allCards: (e)=>
    DeloitteGame.EventDispatcher.trigger 'visiblecards:changed', 'all'
    false

class DeloitteGame.Views.FooterNav extends Backbone.View
  template: Handlebars.compile($("#footer-nav-next").html())

  initialize: ->
    @model.on 'change', @render
    @render()

  render: =>
    @$el.html @template(@model.toJSON())

class DeloitteGame.Views.PageArrowNav extends Backbone.View
  tagName: 'aside'
  template: null

  initialize: ->
    @model.on 'change', @render
    @template = Handlebars.compile($("##{@$el.data('direction')}-arrow-template").html())
    @render()

  render: =>
    @$el.html @template(@model.toJSON())

class DeloitteGame.Views.WindowControll extends Backbone.View
  events:
    'scroll': 'updatedScrollPos'

  initialize: ->
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