################################################################################
# COLLECTIONS
################################################################################
class DeloitteGame.Collections.GameCards extends Backbone.Collection
  model: DeloitteGame.Models.GameCard
  localStorage: new Store "gameCard"
  comparator: 'id'
  initialize: ->
    @on 'change', @changeGameJson
    @on 'change:starred', @checkMaximumStarred

  checkMaximumStarred: (card)=>
    otherCards = @where {starred: true, pile: card.get('pile')}
    card.set('starred', false) if otherCards.length > 5 && card.get('pile') isnt 'out-of-bounds'

  changeGameJson: =>
    cardsObj = []
    @forEach (card)->
      cardsObj.push({id: card.get('id'), pile: card.get('pile'), starred: card.get('starred')})
    DeloitteGame.EventDispatcher.trigger 'collection:changed', JSON.stringify(cardsObj)