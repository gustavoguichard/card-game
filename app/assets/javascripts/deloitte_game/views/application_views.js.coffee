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

class DeloitteGame.Views.FlashMessage extends Backbone.View
  events:
    'click .close': 'dismiss'

  initialize: ->
    @$el.delay(6000).slideUp()

  dismiss: (e)=>
    @$el.clearQueue().slideUp()
    false