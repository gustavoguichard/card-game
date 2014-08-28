################################################################################
# MAIN JS THAT CONTROLS EACH PAGE
################################################################################
DeloitteGame.Pages.Results = 
  init: ->
    cardsList = new DeloitteGame.Collections.GameCards
    # Get's saved cards from localStorage
    cardsList.fetch()
    new DeloitteGame.Views.GameResultsCollection({collection: cardsList})