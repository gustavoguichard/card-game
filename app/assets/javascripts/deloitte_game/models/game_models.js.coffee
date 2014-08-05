################################################################################
# MODELS
################################################################################
class DeloitteGame.Models.GameCard extends Backbone.Model
  defaults:
    id: null
    pile: null
    color: "no-color"
    starred: false

  initialize: ->
    @on 'change:pile', @changeColor
    @on 'change', @saveModel

  saveModel: ->
    @save()
    DeloitteGame.EventDispatcher.trigger 'card:changed'

  updatePile: (pile)=>
    if pile is @get('pile') then @set('pile', null) else @set('pile', pile)

  changeColor: =>
    @set('starred', false)
    if @get('pile')
      color = DeloitteGame.Helpers.getColorFromPile(@get('pile'))
      @set('color', color)
    else
      @set('color', 'no-color')

  toggleStarred: =>
    @set 'starred', !@get("starred")

# RESPONSIBLE FOR SHOWING CARDS AND COUNTING THEM
class DeloitteGame.Models.GameState extends Backbone.Model
  defaults:
    visibleCards: 'all'
    currentView: 'game'
    selectedCardsLength: 0
    totalCardsOfView: 0
    totalCards: 0
    finishedView: false

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
    DeloitteGame.EventDispatcher.trigger 'view:changed', @get('currentView')
    @set {visibleCards: DeloitteGame.Helpers.getColorClassFromView(@get('currentView'))}
    @updateTotalCards()

  updateTotalCards: =>
    if @get('currentView') is 'game'
      @set 'totalCardsOfView', @get('totalCards')
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

  updatePile: (pile)=>
    if pile is @get('pile') then @set('pile', null) else @set('pile', pile)

class DeloitteGame.Models.GameNavigation extends Backbone.Model
  defaults:
    currentView: 'game'
    isViewDone: false

  initialize: ->
    DeloitteGame.EventDispatcher.on 'view:changed', @viewChanged
    DeloitteGame.EventDispatcher.on 'view:done', @viewDone
    @on 'change:currentView', @updateAttrs
    @screens = ['game', 'core', 'adjacent', 'aspirational', 'out-of-bounds']
    @prevLinks = ['http://monitorinstitute.com/communityphilanthropy/toolkit_page/prioritizingroles/', '#game', '#core', '#adjacent', '#aspirational']
    @nextLinks = ['#core', '#adjacent', '#aspirational', '#out-of-bounds', '/participant/new']
    @prevTitles = ['Introduction', 'All Cards', 'Previous Pile', 'Previous Pile', 'Previous Pile']
    @nextTitles = ['Next Pile', 'Next Pile', 'Next Pile', 'Next Pile', 'Registration']
    @updateAttrs()

  viewChanged: (page)=>
    @set 'currentView', page

  viewDone: (done)=>
    @set 'isViewDone', done

  updateAttrs: =>
    index = $.inArray(@get('currentView'), @screens)
    @set {nextLinkTitle: @nextTitles[index], prevLinkTitle: @prevTitles[index], nextLinkUrl: @nextLinks[index], prevLinkUrl: @prevLinks[index]}