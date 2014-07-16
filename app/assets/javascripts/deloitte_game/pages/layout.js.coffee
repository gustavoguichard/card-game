DeloitteGame.Pages ?= {}

DeloitteGame.Pages.Layout = 
  # modules: -> [DeloitteGame.GameCard]
  init: ->
    for $card in $('.game-card')
      new DeloitteGame.GameCard({el: $card})
    for $pile in $('.cards-pile')
      new DeloitteGame.CardsPile({el: $pile})

DeloitteGame.GameCard = Backbone.View.extend
  events:
    'click .select-color': 'colorClicked'
    'click .card-flipper': 'flipCard'
    'pileChange': 'pileChangeHandler'
  initialize: ->
    _.bindAll this, 'colorClicked', 'setPile', 'changeClass', 'pileChangeHandler', 'flipCard'
    @$el.draggable(
      revert: true
      revertDuration: 300
      helper: "clone"
      cursor: "move"
    )
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
    @$el.removeClass 'blue-color purple-color orange-color green-color color-choosed'
    if @color
      @$el.addClass "#{@color}-color color-choosed"

  colorClicked: (e)->
    pile = $(e.currentTarget).data('pile')
    @setPile(pile)

  pileChangeHandler: (e, pile)->
    @setPile(pile) if pile isnt @pile

  flipCard: (e)->
    @$el.toggleClass 'flipped'
    return false
    
DeloitteGame.CardsPile = Backbone.View.extend
  initialize: ->
    @$el.droppable(
      activeClass: "ui-droppable-active"
      hoverClass: "ui-droppable-hover"
      drop: ( event, ui )->
        $(ui.draggable[0]).trigger 'pileChange', $(this).data('pile')
    )