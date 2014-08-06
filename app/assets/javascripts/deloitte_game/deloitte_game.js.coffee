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
  if action is 'Game'
    DeloitteGame.Pages.Game.init()
  else if action is 'Results'
    DeloitteGame.Pages.Results.init()
