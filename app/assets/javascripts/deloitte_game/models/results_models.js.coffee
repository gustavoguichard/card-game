################################################################################
# MODELS
################################################################################
class DeloitteGame.Models.GameResultsGroup extends Backbone.Model
  defaults:
    groupTitle: ''
    groupClass: ''
    cards: []

  initialize: ->
    @on 'change:groupTitle', @setGroupClass
    @setGroupClass()

  setGroupClass: =>
    @set 'groupClass', URLify(@get('groupTitle'))