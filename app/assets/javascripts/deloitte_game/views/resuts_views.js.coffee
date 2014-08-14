################################################################################
# VIEWS
################################################################################
class DeloitteGame.Views.GameResultsCollection extends Backbone.View
  el: '.game-results'
  initialize: ->
    @render()

  render: =>
    @collection.each @renderCard, @

  renderCard: (card)=>
    $card = @$(".game-card-container#game-card-#{card.get('id')}")
    cardView = new DeloitteGame.Views.GameCard({el: $card, model: card})