################################################################################
# MODELS
################################################################################
# RESPONSIBLE FOR SHOWING CARDS AND COUNTING THEM
class DeloitteGame.Models.GameState extends Backbone.Model
  defaults:
    visibleCards: 'all'
    currentView: 'game'
    selectedCardsLength: 0
    totalCardsOfView: 0
    totalCards: 0
    finishedView: false
    isHome: true
    isntHome: false
    isLastScreen: false
    isSingleCard: true
    nextSingleCard: false
    cssTransitions: true

  initialize: ->
    @set('cssTransitions', false) if $('html').hasClass('no-csstransitions')
    @set('gameID', $('body').data('game-id'))
    @on 'change:totalCardsOfView', @updateSelectedCardsLength
    @on 'change:currentView', @updatePageCards
    @on 'change:finishedView', @triggerFinishedView
    DeloitteGame.EventDispatcher.on 'router:changed', @routerChanged
    DeloitteGame.EventDispatcher.on 'visiblecards:changed', @updateVisibleCards
    DeloitteGame.EventDispatcher.on 'card:changed', @updateSelectedCardsLength
    DeloitteGame.EventDispatcher.on 'card:colorclicked', @checkPageDone
    DeloitteGame.EventDispatcher.on 'collection:changed', @updateGameForm
    DeloitteGame.EventDispatcher.on 'collection:persist', @saveGame
    @form = $('form.edit_evaluation')
    @updateTotalCards()
    @checkVisibleCards()

  updateGameForm: (newJSON)=>
    @form.find('#evaluation_data').val(newJSON)

  saveGame: =>
    @form.submit()

  updatePageCards: =>
    if @requireCardsSelected()
      @set 'isHome', @get('currentView') == 'game'
      @set 'isntHome', @get('currentView') != 'game'
      @set 'isLastScreen', @get('currentView') == 'out-of-bounds'
      DeloitteGame.EventDispatcher.trigger 'view:changed', @get('currentView')
      @set {visibleCards: DeloitteGame.Helpers.getColorClassFromView(@get('currentView'))}
      @updateTotalCards()
    @saveGame()

  updateTotalCards: =>
    if @get('currentView') is 'game'
      @set 'totalCardsOfView', @get('totalCards')
    else if @get('currentView') is 'out-of-bounds'
      @set 'totalCardsOfView', $(".game-card-container#{@get('visibleCards')}").length
    else
      @set 'totalCardsOfView', Math.min(5, $(".game-card-container#{@get('visibleCards')}").length)
    @trigger 'change:totalCardsOfView'
    @checkPageDone()

  updateSelectedCardsLength: =>
    if @get('currentView') is 'game'
      @set 'selectedCardsLength', $('.game-card-container.color-choosed').length
    else
      length = $(".game-card-container#{@get('visibleCards')}.starred").length
      @set 'selectedCardsLength', length
    @checkPageDone()
    @checkVisibleCards()

  updateVisibleCards: (filter)=>
    @set 'visibleCards', filter

  requireCardsSelected: =>
    if @get('currentView') != 'game' and $('.game-card-container.color-choosed').length < @get('totalCards')
      Backbone.history.navigate 'game', {trigger: true}
      false
    else
      true

  checkPageDone: (card = null)=>
    if @get('selectedCardsLength') == @get('totalCardsOfView')
      @set 'finishedView', true
    else
      @set 'finishedView', false

  routerChanged: (view)=>
    @set 'currentView', view

  checkVisibleCards: =>
    if @get('currentView') is 'game' and @get('isSingleCard')
      currentCardId = $(".game-card-container.no-color").eq(0).attr('id')
      if currentCardId then currentVisible = ".#{currentCardId}" else currentVisible = "all"
      @set 'visibleCards', currentVisible

  triggerFinishedView: =>
    DeloitteGame.EventDispatcher.trigger 'view:done', @get('finishedView')

class DeloitteGame.Models.PilesContainer extends Backbone.Model
  defaults:
    pile: null
    description: ""
    title: ""

  updatePile: (pile)=>
    if pile is @get('pile') then @set('pile', null) else @set('pile', pile)

class DeloitteGame.Models.GameNavigation extends Backbone.Model
  defaults:
    currentView: 'game'
    isViewDone: false
    isHomeDone: false
    isHome: true
    isntHome: false

  initialize: ->
    DeloitteGame.EventDispatcher.on 'view:changed', @viewChanged
    DeloitteGame.EventDispatcher.on 'view:done', @viewDone
    @on 'change:currentView', @updateAttrs
    @screens = ['game', 'core', 'adjacent', 'aspirational', 'out-of-bounds']
    @prevLinks = ['http://monitorinstitute.com/communityphilanthropy/game/', '#game', '#core', '#adjacent', '#aspirational']
    @nextLinks = ['#core', '#adjacent', '#aspirational', '#out-of-bounds', '/registration']
    @prevTitles = ['Introduction', 'Cards selection', 'Core Pile', 'Adjacent Pile', 'Aspirational Pile']
    @nextTitles = ['Core Pile', 'Adjacent Pile', 'Aspirational Pile', 'Out of Bounds Pile', 'Registration Page']
    @updateAttrs()

  viewChanged: (page)=>
    @set 'currentView', page
    @set 'isHome', @get('currentView') == 'game'
    @set 'isntHome', @get('currentView') != 'game'

  viewDone: (done)=>
    @set 'isViewDone', done
    if !done and @get('currentView') is 'game'
      @set 'isHomeDone', false
    else
      @set 'isHomeDone', true


  updateAttrs: =>
    index = $.inArray(@get('currentView'), @screens)
    @set {nextLinkTitle: @nextTitles[index], prevLinkTitle: @prevTitles[index], nextLinkUrl: @nextLinks[index], prevLinkUrl: @prevLinks[index]}