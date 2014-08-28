################################################################################
# MAIN JS THAT CONTROLS EACH PAGE
################################################################################
DeloitteGame.Pages.Registration = 
  init: ->
    cardsList = new DeloitteGame.Collections.GameCards
    # Get's saved cards from localStorage
    cardsList.fetch()
    cardsObj = []
    for i in [0..46]
      if localStorage.getItem("gameCard-#{i+1}")
        cardsObj[i] = {}
        cardsObj[i]['id'] = JSON.parse(localStorage.getItem("gameCard-#{i+1}"))["id"]
        cardsObj[i]['pile'] = JSON.parse(localStorage.getItem("gameCard-#{i+1}"))["pile"]
        cardsObj[i]['starred'] = JSON.parse(localStorage.getItem("gameCard-#{i+1}"))["starred"]
    $('#evaluation_data').val JSON.stringify(cardsObj)