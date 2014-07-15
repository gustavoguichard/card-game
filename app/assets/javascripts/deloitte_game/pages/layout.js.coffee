DeloitteGame.Pages ?= {}

DeloitteGame.Pages.Layout =
  init: ->
    $('a[href~=#]').on 'click', (e)->
      return false

  # modules: -> []