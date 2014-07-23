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

  cardSelectedHandler: ->
    alert "Hey"

DeloitteGame.GameCard = Backbone.View.extend
  events:
    'click .select-color': 'colorClicked'
    'click .card-flipper': 'flipCard'
    'pileChange': 'pileChangeHandler'
  initialize: ->
    _.bindAll @, 'colorClicked', 'setPile', 'changeClass', 'pileChangeHandler', 'flipCard'
    @$el.draggable(
      revert: true
      revertDuration: 300
      helper: "clone"
      cursor: "move"
    )
    @card = @$el.find('.game-card')
    @colorOpts = ['blue', 'green', 'purple', 'orange']
    @pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
    @pile = null
    @color = null

  setPile: (pile)->
    index = jQuery.inArray(pile, @pileOpts)
    if pile == @pile
      @pile = null
      @color = null
    else
      @pile = pile
      @color = @colorOpts[index]
    @changeClass()

  changeClass: ->
    @card.removeClass 'blue-color purple-color orange-color green-color color-choosed'
    @$('.select-color').removeClass 'selected'
    if @color
      @card.addClass "#{@color}-color color-choosed"
      @$(".select-color.#{@color}-color").addClass 'selected'
    @model.cardSelected()

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

DeloitteGame.PilesContainer = Backbone.View.extend
  initialize: ->
    @$el.waypoint('sticky')

DeloitteGame.FooterCounter = Backbone.View.extend
  initialize: ->
    @model.on 'change', @render, @
    @counter = @$('#cards-counter')

  render: ->
    @counter.html "You have chosen #{@model.get('selectedCards')} out of #{@model.get('totalCards')} possible cards"    

DeloitteGame.GameModel = Backbone.Model.extend
  defaults:
    currentPage: 'home'
    selectedCards: 0
    totalCards: 0

  initialize: ->
    _.bindAll @, 'cardSelected'
    @set 'totalCards', $('.game-card-container').length

  cardSelected: ->
    @set 'selectedCards', $('.game-card-container .color-choosed').length