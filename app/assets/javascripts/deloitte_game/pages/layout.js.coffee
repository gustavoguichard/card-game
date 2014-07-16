DeloitteGame.Pages ?= {}

DeloitteGame.Pages.Layout = 
  # modules: -> [DeloitteGame.GameCard]
  init: ->
    for $card in $('.game-card')
      new DeloitteGame.GameCard({el: $card})

DeloitteGame.GameCard = Backbone.View.extend
  events:
    'click .select-color': 'colorClicked'
  initialize: ->
    _.bindAll this, 'colorClicked', 'setPile', 'changeClass'
    @colorOpts = ['blue', 'green', 'purple', 'orange']
    @pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
    @pile = null

  mouseEnter: (e)->
    console.log e.currentTarget

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
    @setPile(pile) if pile
    