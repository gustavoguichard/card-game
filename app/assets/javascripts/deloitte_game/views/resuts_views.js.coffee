################################################################################
# VIEWS
################################################################################
class DeloitteGame.Views.GameResultsCollection extends Backbone.View
  el: '.game-results'
  initialize: ->
    @piles = {core: 'Core', adjacent: 'Adjacent', aspirational: 'Aspirational', 'out-of-bounds': 'Out of Bounds'}
    @render()

  render: =>
    html = ""
    # for pile, pileTitle of @piles
    #   group =  _.groupBy(@collection.where({pile: pile, starred: true}), (card)-> card.attributes.action)
    #   groupView = new DeloitteGame.Views.GameResultsGroup {group: group, title: pileTitle}
    #   html += groupView.render().el
    console.log html

# class DeloitteGame.Views.GameResultsGroup extends Backbone.View
#   tagName: 'section'
#   initialize: ->

# class DeloitteGame.Views.GameResultsAction extends Backbone.View
#   