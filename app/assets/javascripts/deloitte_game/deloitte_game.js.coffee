#= require_self
#= require_tree ./helpers
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require_tree ./pages

window.DeloitteGame ?= {}
DeloitteGame.Models ?= {}
DeloitteGame.Views ?= {}
DeloitteGame.Collections ?= {}
DeloitteGame.Helpers ?= {}
DeloitteGame.Router ?= {}
DeloitteGame.Pages ?= {}
DeloitteGame.EventDispatcher = _.extend {}, Backbone.Events
DeloitteGame.PageStarted = false

$ ->
  action =  $('#init-js').data('action')
  resource =  $('#init-js').data('resource')
  if resource is 'Pages'
    if action is 'Game'
      DeloitteGame.Pages.Game.init()
  else if resource is 'Evaluations'
    if action is 'New'
      DeloitteGame.Pages.Registration.init()
    else if action is 'Show'
      DeloitteGame.Pages.Results.init()

  for $togglr in $('.navbar-toggle')
    new DeloitteGame.Views.MenuTogglr({el: $togglr})