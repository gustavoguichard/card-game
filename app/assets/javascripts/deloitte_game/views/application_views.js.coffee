################################################################################
# VIEWS
################################################################################
class DeloitteGame.Views.MenuTogglr extends Backbone.View
  events:
    'click': 'toggleClicked'

  initialize: ->
    targetSelector = @$el.data('target')
    @target = $(targetSelector).first()
  
  toggleClicked: (e)=>
    @target.toggleClass('is-open')
