################################################################################
# MAIN JS THAT CONTROLS EACH PAGE
################################################################################
DeloitteGame.Pages.Results = 
  init: ->
    $('.new-game-bt').on 'click', ->
      localStorage.clear()
      true