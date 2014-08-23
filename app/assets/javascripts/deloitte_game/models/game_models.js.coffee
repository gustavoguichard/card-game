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

  initialize: ->
    @on 'change:totalCardsOfView', @updateSelectedCardsLength
    @on 'change:currentView', @updatePageCards
    @on 'change:finishedView', @triggerFinishedView
    DeloitteGame.EventDispatcher.on 'router:changed', @routerChanged
    DeloitteGame.EventDispatcher.on 'visiblecards:changed', @updateVisibleCards
    DeloitteGame.EventDispatcher.on 'card:changed', @updateSelectedCardsLength
    DeloitteGame.EventDispatcher.on 'card:colorclicked', @checkPageDone
    @updateTotalCards()

  updatePageCards: =>
    if @requireCardsSelected()
      @set 'isHome', @get('currentView') == 'game'
      DeloitteGame.EventDispatcher.trigger 'view:changed', @get('currentView')
      @set {visibleCards: DeloitteGame.Helpers.getColorClassFromView(@get('currentView'))}
      @updateTotalCards()

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

  initialize: ->
    DeloitteGame.EventDispatcher.on 'view:changed', @viewChanged
    DeloitteGame.EventDispatcher.on 'view:done', @viewDone
    @on 'change:currentView', @updateAttrs
    @screens = ['game', 'core', 'adjacent', 'aspirational', 'out-of-bounds']
    @prevLinks = ['http://monitorinstitute.com/communityphilanthropy/toolkit_page/prioritizingroles/', '#game', '#core', '#adjacent', '#aspirational']
    @nextLinks = ['#core', '#adjacent', '#aspirational', '#out-of-bounds', '/results']
    @prevTitles = ['Introduction', 'Cards selection', 'Core Pile', 'Adjacent Pile', 'Aspirational Pile']
    @nextTitles = ['Core Pile', 'Adjacent Pile', 'Aspirational Pile', 'Out of Bounds Pile', 'Results Page']
    @updateAttrs()

  viewChanged: (page)=>
    @set 'currentView', page

  viewDone: (done)=>
    @set 'isViewDone', done
    if !done and @get('currentView') is 'game'
      @set 'isHomeDone', false
    else
      @set 'isHomeDone', true


  updateAttrs: =>
    index = $.inArray(@get('currentView'), @screens)
    @set {nextLinkTitle: @nextTitles[index], prevLinkTitle: @prevTitles[index], nextLinkUrl: @nextLinks[index], prevLinkUrl: @prevLinks[index]}