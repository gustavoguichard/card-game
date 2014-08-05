################################################################################
# ROUTER
################################################################################
class DeloitteGame.Router extends Backbone.Router
  routes:
    ':view': 'viewHandler'

  viewHandler: (view)=>
    DeloitteGame.EventDispatcher.trigger 'router:changed', view