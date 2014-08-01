DeloitteGame.Helpers.getColorFromPile = (pile)->
  colorOpts = ['blue', 'green', 'purple', 'orange']
  pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
  index = $.inArray(pile, pileOpts)
  newColor = colorOpts[index]
  return "#{newColor}-color"

DeloitteGame.Pages ?= {}

# METHOD TO INITIALIZE JS OF PAGE
DeloitteGame.Pages.Game = 
  init: ->
    $cards = $('.game-card-container')
    @cardsList = new DeloitteGame.Collections.GameCards
    @cardsList.fetch()
    unless @cardsList.models.length is $cards.length
      for card in $cards
        model = new DeloitteGame.Models.GameCard({id: $(card).data('card-id')})
        @cardsList.create model
    window.cardsCollectionView = new DeloitteGame.Views.GameCardsCollection({collection: @cardsList})
    # CARDS CONTAINER AND COUNT
    cardsLength = $cards.length
    cardsContainerModel = new DeloitteGame.Models.GameCardsContainer {totalCards: cardsLength}
    @footerCount = new DeloitteGame.Views.FooterCounter({el: $('.footer-count').first(), model: cardsContainerModel})
    @gameCardsContainer = new DeloitteGame.Views.GameCardsContainer({el: $('.cards-container').first(), model: cardsContainerModel})
    # CONTROLS
    @footerNav = new DeloitteGame.Views.FooterNav({el: $('.footer-nav').first(), model: cardsContainerModel})
    # PILES CONTAINER
    pilesContainerModel = new DeloitteGame.Models.PilesContainer
    @pilesContainer = new DeloitteGame.Views.PilesContainer({el: $('.piles-container').first(), model: pilesContainerModel})
    # GAME MODEL
    # window.gameData = new DeloitteGame.Models.GameData {cardsChoosen: gameJson}

# GAME CARD CLASSES
class DeloitteGame.Models.GameCard extends Backbone.Model
  defaults:
    id: null
    pile: null
    color: "no-color"
    starred: false

  initialize: ->
    @on 'change:pile', @changeColor

  updatePile: (pile)=>
    if pile is @get('pile') then @save({pile: null}) else @save({pile: pile})

  changeColor: =>
    if @get('pile')
      color = DeloitteGame.Helpers.getColorFromPile(@get('pile'))
      @save {color: color}
    else
      @save {color: 'no-color'}

  toggleStarred: =>
    @save {starred: !@get("starred")}

class DeloitteGame.Collections.GameCards extends Backbone.Collection
  model: DeloitteGame.Models.GameCard
  localStorage: new Backbone.LocalStorage "gameCards"
  comparator: 'id'

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
    @model.on 'change:color', @render
    # @$el.draggable(
    #   revert: true
    #   revertDuration: 300
    #   helper: "clone"
    #   cursor: "move"
    # )
    @render()

  render: =>
    @clearClasses()
    @$el.addClass @model.get('color')
    @$el.addClass('color-choosed') if @model.get('pile')
    @$(".select-color.#{@model.get('color')}").addClass 'selected'

  starCard: =>
    @model.toggleStarred()
    @$el.toggleClass 'starred'

  clearClasses: =>
    @$el.removeClass 'blue-color purple-color orange-color green-color no-color color-choosed'
    @$('.select-color').removeClass 'selected'

  colorClicked: (e)=>
    @model.updatePile $(e.currentTarget).data('pile')

  flipCard: (e)=>
    @$el.find('.game-card').toggleClass 'flipped'
    false    

class DeloitteGame.Collections.GameCards extends Backbone.Collection
  model: DeloitteGame.Models.GameCard
  localStorage: new Backbone.LocalStorage "gameCards"
  initialize: ->
    # new DeloitteGame.Views.GameCard({el: $(card), model: model})  

  createModelsFromCards: ->
    for card in $('.game-card-container')
      model = new DeloitteGame.Models.GameCard({id: $(card).data('card-id')})
      @add model

# CLASSES FOR CARDS CONTAINER, RESPONSIBLE FOR MIXING CARDS AND COUNTING THEM
class DeloitteGame.Models.GameCardsContainer extends Backbone.Model
  defaults:
    visibleCards: 'all'
    currentView: 'home'
    selectedCardsLength: 0
    totalCardsOfView: 0
    totalCards: 0

  initialize: ->
    @on 'change:totalCardsOfView', @updateSelectedCardsLength
    DeloitteGame.EventDispatcher.on 'visiblecards:changed', @updateVisible
    DeloitteGame.EventDispatcher.on 'json:changed', @updateSelectedCardsLength
    DeloitteGame.EventDispatcher.on 'page:changed', @updatePageCards
    @updateTotalCards()

  updatePageCards: (page, json)=>
    @set 'currentView', page
    if page is 'home'
      @set 'visibleCards', 'all'
    else
      @set 'visibleCards', ".#{DeloitteGame.Helpers.getColorFromPile(page)}"
    @updateTotalCards()

  updateTotalCards: =>
    if @get('currentView') is 'home'
      @set 'totalCardsOfView', @get('totalCards')
    else
      # @set 'totalCardsOfView', $(".game-card-container#{@get('visibleCards')}").length
      @set 'totalCardsOfView', 5

  updateSelectedCardsLength: (json = {})=>
    if @get('currentView') is 'home'
      @set 'selectedCardsLength', _.size(json)
    else
      length = $(".game-card-container#{@get('visibleCards')}.starred").length
      @set 'selectedCardsLength', length
    @checkPageDone()

  checkPageDone: =>
    DeloitteGame.EventDispatcher.trigger 'page:done' if @get('selectedCardsLength') == @get('totalCardsOfView')

  updateVisible: (filter)=>
    @set 'visibleCards', filter

class DeloitteGame.Views.GameCardsContainer extends Backbone.View
  initialize: ->
    @model.on 'change:visibleCards', @sortCards
    @model.on 'change:currentView', @changeContainerClass
    @$el.mixItUp
        animation:
          duration: 940
          effects: 'fade translateZ(-360px) rotateY(-100deg) stagger(50ms)'
          easing: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
        selectors:
          target: '.game-card-container'

  sortCards: =>
    @$el.mixItUp 'filter', @model.get('visibleCards')

  changeContainerClass: =>
    @$el.removeClass 'home core adjacent aspirational out-of-bounds'
    @$el.addClass @model.get('currentView')

# RESPONSIBLE FOR PILES CONTAINER INTERACTIONS LIKE STICKING
# TO TOP AND OPENING DESCRIPTIONS WHEN IN SMALL SCREENS
class DeloitteGame.Models.PilesContainer extends Backbone.Model
  defaults:
    pile: null
    description: ""

  updatePile: (pile)=>
    if pile is @get('pile') then @set('pile', null) else @set('pile', pile)

class DeloitteGame.Views.PilesContainer extends Backbone.View
  events:
    'click .cards-pile': 'cardsPileClicked'
  initialize: ->
    @$el.append('<div id="floating-pile-description">')
    @$el.waypoint('sticky')
    # @bindDropping()
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

  # bindDropping: =>
  #   for pile in @$('.cards-pile')
  #     $(pile).droppable(
  #       hoverClass: "ui-droppable-hover"
  #       drop: ( event, ui )->
  #         DeloitteGame.EventDispatcher.trigger('card:changed', $(ui.helper[0]).data('card-id'), $(this).data('pile'))
  #     )

# RESPONSIBLE TO CHANGE FOOTER COUNTER WHEN A NEW CARD IS SELECTED
class DeloitteGame.Views.FooterCounter extends Backbone.View
  tagName: 'span'
  template: _.template($('#cards-counter').html())

  initialize: ->
    @model.on 'change', @render
    @render()

  render: =>
    @$el.html @template(@model.toJSON())

class DeloitteGame.Views.FooterNav extends Backbone.View
  events: ->
    'click .cards-left-bt': 'leftCards'
    'click .cards-all-bt': 'allCards'

  leftCards: (e)=>
    DeloitteGame.EventDispatcher.trigger 'visiblecards:changed', '.no-color'
    false

  allCards: (e)=>
    DeloitteGame.EventDispatcher.trigger 'visiblecards:changed', 'all'
    false

# TAKES CARE OF DATA OF ENTIRE GAME
# class DeloitteGame.Models.GameData extends Backbone.Model
#   defaults:
#     currentPage: 'home'
#     selectedCardsLength: 0
#     totalCards: 0
#     cardsChoosen: {}

#   initialize: ->
#     @on 'change:cardsChoosen', @jsonChanged
#     @on 'change:currentPage', @pageChanged
#     DeloitteGame.EventDispatcher.on 'card:changed', @pushCard
#     DeloitteGame.EventDispatcher.on 'card:star', @starCard
#     @json = @get('cardsChoosen')
#     @jsonChanged()

#   jsonChanged: =>
#     DeloitteGame.EventDispatcher.trigger 'json:changed', @json

#   pageChanged: =>
#     DeloitteGame.EventDispatcher.trigger 'page:changed', @get('currentPage')

#   pushCard: (card, pile)=>
#     @json[card] = pile
#     @cleanJson() if @json?
#     @set 'cardsChoosen', @json
#     @trigger 'change:cardsChoosen'
#     store.set "cardsChoosen", @json

#   cleanJson: =>
#     $.each @json, (key, value)=>
#       delete @json[key] unless value?

#   starCard: (model)=>
#     console.log model