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
    'customEvent': 'customFunction'
  initialize: ->
    _.bindAll this, 'colorClicked', 'setPile', 'changeClass', 'customFunction'
    @$el.draggable(
      revert: true
      revertDuration: 300
      helper: "clone"
      cursor: "move"
    )
    @colorOpts = ['blue', 'green', 'purple', 'orange']
    @pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
    @pile = null

  setPile: (pile)->
    index = jQuery.inArray(pile, @pileOpts)
    if @colorOpts[index] == @pile then @pile = null else @pile = @colorOpts[index]
    @changeClass()

  changeClass: ->
    @$el.removeClass 'blue-color purple-color orange-color green-color color-choosed'
    if @pile
      @$el.addClass "#{@pile}-color color-choosed"

  colorClicked: (e)->
    pile = $(e.currentTarget).data('pile')
    @setPile(pile)

  customFunction: (e, pile)->
    @setPile(pile)
    
DeloitteGame.CardsPile = Backbone.View.extend
  initialize: ->
    @$el.droppable(
      activeClass: "ui-droppable-active"
      hoverClass: "ui-droppable-hover"
      drop: ( event, ui )->
        $(ui.draggable[0]).trigger 'customEvent', $(this).data('pile')
    )