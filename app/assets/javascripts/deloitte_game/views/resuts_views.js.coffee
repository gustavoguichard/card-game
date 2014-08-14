################################################################################
# VIEWS
################################################################################
class DeloitteGame.Views.GameResultsCollection extends Backbone.View
  el: '.game-results'
  initialize: ->
    @piles = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
    @render()

  render: =>
    for pile in @piles
      group =  _.groupBy(@collection.where({pile: pile, starred: true}), (card)-> card.attributes.action)
      for title, cards of group
        cardsJSON = cards.map((card)-> card.toJSON())
        model = new DeloitteGame.Models.GameResultsGroup {groupTitle: title, cards: cardsJSON}
        groupView = new DeloitteGame.Views.GameResultsGroup {model: model}
        @$(".pile-group.#{pile}").append(groupView.render().el)

class DeloitteGame.Views.GameResultsGroup extends Backbone.View
  tagName: 'ul'
  template: null
  initialize: ->
    @template = Handlebars.compile($('#card-action-group').html())
  
  render: =>
    @$el.html @template(@model.toJSON())
    return @
