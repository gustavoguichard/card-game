################################################################################
# MAIN JS THAT CONTROLS EACH PAGE
################################################################################
DeloitteGame.Pages.Results = 
  init: ->
    $('.new-game-bt').on 'click', ->
      confirmation = confirm "Are you sure you want to START THE GAME OVER AGAIN?"
      if confirmation
        localStorage.clear()
        true
      else
        false