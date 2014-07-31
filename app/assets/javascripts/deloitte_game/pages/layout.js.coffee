DeloitteGame.Pages ?= {}

DeloitteGame.Pages.Layout = 
  # modules: -> [DeloitteGame.Views.GameCard]
  init: ->
    gameJson = store.get("cardsChoosen") || {}
    $cards = $('.game-card-container')
    cardsLength = $cards.length
    @model = new DeloitteGame.Models.Game {cardsChoosen: gameJson, totalCards: cardsLength}
    @gameCards = []
    @cardsPile = []
    for $card in $cards
      @gameCards.push new DeloitteGame.Views.GameCard({el: $card, model: @model})
    for $pile in $('.cards-pile')
      @cardsPile.push new DeloitteGame.Views.CardsPile({el: $pile})
    @pilesContainer = new DeloitteGame.Views.PilesContainer({el: $('.piles-container').first()})
    @footerCount = new DeloitteGame.Views.FooterCounter({el: $('.footer-count').first(), model: @model})
    @footerCount = new DeloitteGame.Views.FooterNav({el: $('.footer-nav').first(), model: @model})
    @gameCardsContainer = new DeloitteGame.Views.GameCardsContainer({el: $('.cards-container').first(), model: @model})

class DeloitteGame.Views.GameCard extends Backbone.View
  events:
    'click .select-color': 'colorClicked'
    'click .card-flipper': 'flipCard'
  initialize: ->
    @id = @$el.data('card-id')
    @model.on 'change:cardsChoosen', @render
    @$el.draggable(
      revert: true
      revertDuration: 300
      helper: "clone"
      cursor: "move"
    )
    @card = @$el.find('.game-card')
    @colorOpts = ['blue', 'green', 'purple', 'orange']
    @pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
    @render()

  render: =>
    if @model.get('cardsChoosen')
      index = -1
      if @model.get('cardsChoosen')[@id]
        index = jQuery.inArray(@model.get('cardsChoosen')[@id], @pileOpts)
      @$el.removeClass 'blue-color purple-color orange-color green-color no-color color-choosed'
      @$('.select-color').removeClass 'selected'
      if index >= 0
        newColor = @colorOpts[index]
        @$el.addClass "#{newColor}-color color-choosed"
        @$(".select-color.#{newColor}-color").addClass 'selected'
      else
        @$el.addClass "no-color"

  setPile: (pile)=>
    if pile == @model.get('cardsChoosen')[@id] then pile = null
    @model.pushCard @id, pile

  colorClicked: (e)=>
    pile = $(e.currentTarget).data('pile')
    @setPile(pile)

  flipCard: (e)=>
    @card.toggleClass 'flipped'
    return false    

class DeloitteGame.Views.GameCardsContainer extends Backbone.View
  initialize: ->
    @model.on 'change:visibleCards', @sortCards
    @$el.mixItUp
        animation:
          duration: 940
          effects: 'fade translateZ(-360px) rotateY(-100deg) stagger(50ms)'
          easing: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
        selectors:
          target: '.game-card-container'


  sortCards: =>
    @$el.mixItUp 'filter', @model.get('visibleCards')
    
class DeloitteGame.Views.CardsPile extends Backbone.View
  initialize: ->
    @$el.droppable(
      activeClass: "ui-droppable-active"
      hoverClass: "ui-droppable-hover"
      drop: ( event, ui )->
        DeloitteGame.EventDispatcher.trigger('card:dropped', $(ui.helper[0]).data('card-id'), $(this).data('pile'))
    )

# RESPONSIBLE FOR PILES CONTAINER INTERACTIONS LIKE STICKING
# TO TOP AND OPENING DESCRIPTIONS WHEN IN SMALL SCREENS
class DeloitteGame.Views.PilesContainer extends Backbone.View
  events:
    'click .cards-pile': 'cardsPileClicked'
  initialize: ->
    @$el.append('<div id="floating-pile-description">')
    @$el.waypoint('sticky')
    @floatingPileDescrition = @$('#floating-pile-description')
    @currentOpenPile = null

  cardsPileClicked: (e)=>
    $tg = $(e.currentTarget)
    @$('.cards-pile').removeClass 'open-pile'
    @floatingPileDescrition.removeClass 'open core adjacent out-of-bounds aspirational'
    unless @currentOpenPile is $tg.data('pile')
      @openPileDescription($tg)
    else
      @currentOpenPile = null

  openPileDescription: ($tg)=>
    @currentOpenPile = $tg.data 'pile'
    description = $tg.find('.pile-description').html()
    $tg.addClass 'open-pile'
    @floatingPileDescrition.addClass("open #{$tg.data 'pile'}")
    @floatingPileDescrition.html(description)

# RESPONSIBLE TO CHANGE FOOTER COUNTES WHEN A NEW CARD IS SELECTED
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
    @model.set 'visibleCards', '.no-color'
    false

  allCards: (e)=>
    @model.set 'visibleCards', 'all'
    false

# TAKES CARE OF DATA OF ENTIRE GAME
class DeloitteGame.Models.Game extends Backbone.Model
  defaults:
    currentPage: 'home'
    selectedCardsLenght: 0
    totalCards: 0
    cardsChoosen: {}
    gameScreen: "all"
    visibleCards: "all"

  initialize: ->
    @on 'change:cardsChoosen', @cardSelected
    DeloitteGame.EventDispatcher.on 'card:dropped', @pushCard
    @json = @get('cardsChoosen')
    @cardSelected()

  cardSelected: =>
    @set 'selectedCardsLenght', _.size(@get 'cardsChoosen')

  pushCard: (card, pile)=>
    @json[card] = pile
    @cleanJson() if @json?
    @set 'cardsChoosen', null
    @set 'cardsChoosen', @json
    store.set "cardsChoosen", @json

  cleanJson: =>
    $.each @json, (key, value)=>
      delete @json[key] unless value?