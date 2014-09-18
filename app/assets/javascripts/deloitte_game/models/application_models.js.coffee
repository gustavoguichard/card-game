################################################################################
# MODELS
################################################################################
class DeloitteGame.Models.GameCard extends Backbone.Model
  defaults:
    id: null
    pile: null
    color: "no-color"
    starred: false
    action: ''
    title: ''
    defaultChecked: true

  initialize: ->
    @on 'change:pile', @changeColor
    @on 'change', @saveModel

  saveModel: ->
    @save()
    DeloitteGame.EventDispatcher.trigger 'card:changed'

  updatePile: (pile)=>
    if pile is @get('pile') then @set('pile', null) else @set('pile', pile)
    if pile is 'out-of-bounds' and @get('defaultChecked') then @set('starred', true)

  changeColor: =>
    @set('starred', false)
    if @get('pile')
      color = DeloitteGame.Helpers.getColorFromPile(@get('pile'))
      @set('color', color)
    else
      @set('color', 'no-color')

  toggleStarred: =>
    @set 'starred', !@get("starred")
    @set('defaultChecked', false) if @get('pile') is 'out-of-bounds'