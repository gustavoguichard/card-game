DeloitteGame.Pages ?= {}

DeloitteGame.Pages.Layout = 
  # modules: -> [DeloitteGame.GameCard]
  init: ->
    @model = new DeloitteGame.GameModel
    @gameCards = []
    @cardsPile = []
    for $card in $('.game-card-container')
      @gameCards.push new DeloitteGame.GameCard({el: $card, model: @model})
    for $pile in $('.cards-pile')
      @cardsPile.push new DeloitteGame.CardsPile({el: $pile})
    @pilesContainer = new DeloitteGame.PilesContainer({el: $('.piles-container').first()})
    @footerCount = new DeloitteGame.FooterCounter({el: $('.footer-count').first(), model: @model})
    $('.cards-container').mixItUp
        animation:
          duration: 940
          effects: 'fade translateZ(-360px) rotateY(-100deg) stagger(50ms)'
          easing: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
        selectors:
          target: '.game-card-container'

DeloitteGame.GameCard = Backbone.View.extend
  events:
    'click .select-color': 'colorClicked'
    'click .card-flipper': 'flipCard'
    'pileChange': 'pileChangeHandler'
  initialize: ->
    _.bindAll @, 'colorClicked', 'setPile', 'pileChangeHandler', 'flipCard', 'render'
    @model.on 'change:cardsChoosen', @render, @
    @$el.draggable(
      revert: true
      revertDuration: 300
      helper: "clone"
      cursor: "move"
    )
    @card = @$el.find('.game-card')
    @colorOpts = ['blue', 'green', 'purple', 'orange']
    @pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
    @id = @$el.data('card-id')
    @pile = null
    @color = null
    @setPile(@model.get('cardsChoosen')[@id]) if @model.get('cardsChoosen')[@id]

  render: ->
    @$el.removeClass 'blue-color purple-color orange-color green-color no-color color-choosed'
    @$('.select-color').removeClass 'selected'
    if @color
      @$el.addClass "#{@color}-color color-choosed"
      @$(".select-color.#{@color}-color").addClass 'selected'
    else
      @$el.addClass "no-color"

  setPile: (pile)->
    index = jQuery.inArray(pile, @pileOpts)
    if pile == @pile
      @pile = null
      @color = null
    else
      @pile = pile
      @color = @colorOpts[index]
    @model.pushCard @id, @pile 

  colorClicked: (e)->
    pile = $(e.currentTarget).data('pile')
    @setPile(pile)

  pileChangeHandler: (e, pile)->
    @setPile(pile) if pile isnt @pile

  flipCard: (e)->
    @card.toggleClass 'flipped'
    return false    
    
DeloitteGame.CardsPile = Backbone.View.extend
  initialize: ->
    @$el.droppable(
      activeClass: "ui-droppable-active"
      hoverClass: "ui-droppable-hover"
      drop: ( event, ui )->
        $(ui.draggable[0]).trigger 'pileChange', $(this).data('pile')
    )

# RESPONSIBLE FOR PILES CONTAINER INTERACTIONS LIKE STICKING
# TO TOP AND OPENING DESCRIPTIONS WHEN IN SMALL SCREENS
DeloitteGame.PilesContainer = Backbone.View.extend
  events:
    'click .cards-pile': 'cardsPileClicked'
  initialize: ->
    _.bindAll @, 'cardsPileClicked', 'openPileDescription'
    @$el.append('<div id="floating-pile-description">')
    @$el.waypoint('sticky')
    @floatingPileDescrition = @$('#floating-pile-description')
    @currentOpenPile = null

  cardsPileClicked: (e)->
    $tg = $(e.currentTarget)
    @$('.cards-pile').removeClass 'open-pile'
    @floatingPileDescrition.removeClass 'open core adjacent out-of-bounds aspirational'
    unless @currentOpenPile is $tg.data('pile')
      @openPileDescription($tg)
    else
      @currentOpenPile = null

  openPileDescription: ($tg)->
    @currentOpenPile = $tg.data 'pile'
    description = $tg.find('.pile-description').html()
    $tg.addClass 'open-pile'
    @floatingPileDescrition.addClass("open #{$tg.data 'pile'}")
    @floatingPileDescrition.html(description)

# RESPONSIBLE TO CHANGE FOOTER COUNTES WHEN A NEW CARD IS SELECTED
DeloitteGame.FooterCounter = Backbone.View.extend
  events: ->
    'click .cards-left-bt': 'leftCards'

  initialize: ->
    _.bindAll @, 'render', 'leftCards'
    @model.on 'change', @render, @
    @counter = @$('#cards-counter')
    @total = @$('#cards-total')
    @render()

  render: ->
    @counter.html @model.get('selectedCardsLenght')
    @total.html @model.get('totalCards')

  leftCards: (e)->
    $('.cards-container').mixItUp('filter', '.no-color')
    false

# TAKES CARE OF DATA OF ENTIRE GAME
DeloitteGame.GameModel = Backbone.Model.extend
  defaults:
    currentPage: 'home'
    selectedCardsLenght: 0
    totalCards: 0
    cardsChoosen: {}
    gameScreen: "all"

  initialize: ->
    _.bindAll @, 'cardSelected', 'pushCard', 'cleanJson'
    @on 'change:cardsChoosen', @cardSelected, @
    @json = store.get("cardsChoosen") || {}
    @set 'cardsChoosen', @json
    @set 'selectedCardsLenght', 0
    @set 'totalCards', $('.game-card-container').length

  cardSelected: ->
    @set 'selectedCardsLenght', _.size(@json)

  pushCard: (card, pile)->
    @json[card] = pile
    @cleanJson() if @json?
    @set 'cardsChoosen', null
    @set 'cardsChoosen', @json
    store.set "cardsChoosen", @json

  cleanJson: ->
    $.each @json, (key, value)=>
      delete @json[key] unless value?