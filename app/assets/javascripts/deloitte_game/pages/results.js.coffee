################################################################################
# MAIN JS THAT CONTROLS EACH PAGE
################################################################################
DeloitteGame.Pages.Results = 
  init: ->
    window.cardsList = new DeloitteGame.Collections.GameCards
    # Get's saved cards from localStorage
    cardsList.fetch()