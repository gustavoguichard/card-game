#= require_tree ../helpers
#= require_tree ../models
#= require_tree ../collections
#= require_tree ../views
#= require_tree ../routers

################################################################################
# MAIN JS THAT CONTROLS EACH PAGE
################################################################################
DeloitteGame.Pages.Game = 
  init: ->
    # Initializes Backbone Routes
    new DeloitteGame.Router
    Backbone.history.start() unless Backbone.History.started
    # Creates a collection of cards and if there is no saved cards,
    # it instantiates one card model for each HTML Card and puts it in the collection
    $cards = $('.game-card-container')
    cardsList = new DeloitteGame.Collections.GameCards
    # Get's saved cards from localStorage
    cardsList.fetch()
    unless cardsList.length is $cards.length
      for card in $cards
        model = new DeloitteGame.Models.GameCard({id: $(card).data('card-id')})
        cardsList.create model
    # Instantiates the view to the collection of cards
    new DeloitteGame.Views.GameCardsCollection({collection: cardsList})
    # Instantiates the model that controlls navigation between views
    navigationModel = new DeloitteGame.Models.GameNavigation()
    # Instantiates the Game Model that controlls the game state, visible cards and
    # if each stage is completed
    cardsLength = $cards.length
    gameStateModel = new DeloitteGame.Models.GameState {totalCards: cardsLength}
    new DeloitteGame.Views.GameState({el: $('.cards-container').first(), model: gameStateModel})
    # Instantiates the footer cards counter controlled by Game Model
    new DeloitteGame.Views.FooterCounter({el: $('.counter-nav').first(), model: gameStateModel})
    # Instantiates Model and View for the piles controller, responsible for sticking it to top
    # and opening it's instructions
    pilesContainerModel = new DeloitteGame.Models.PilesContainer
    new DeloitteGame.Views.PilesContainer({el: $('.piles-container').first(), model: pilesContainerModel})
    # Instantiates the prev and next arrows
    for arrow in $('.arrow-nav')
      new DeloitteGame.Views.PageArrowNav({el: $(arrow), model: navigationModel})
    # Instantiates Footer navigation that shows up when user has finished a view
    new DeloitteGame.Views.FooterNav({el: $('.footer-nav-next').first(), model: navigationModel})
    # Instantiates a window controller to listen to the global window events
    new DeloitteGame.Views.WindowControll {el: $(window), model: gameStateModel}
    # Goes to #game view if it's in root path, otherwise it tells the current view to the game
    if Backbone.history.fragment == ''
      Backbone.history.navigate 'game', {trigger: true}
    else
      DeloitteGame.EventDispatcher.trigger 'router:changed', Backbone.history.fragment