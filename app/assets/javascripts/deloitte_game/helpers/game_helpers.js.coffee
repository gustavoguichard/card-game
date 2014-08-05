################################################################################
# HELPERS
################################################################################
# Returns a color class from a pile name
DeloitteGame.Helpers.getColorFromPile = (pile)->
  colorOpts = ['blue', 'green', 'purple', 'orange']
  pileOpts = ['core', 'adjacent', 'aspirational', 'out-of-bounds']
  index = $.inArray(pile, pileOpts)
  newColor = colorOpts[index]
  return "#{newColor}-color"
# Returns a color class from a view name
DeloitteGame.Helpers.getColorClassFromView = (view)->
  if view is 'game' or view is ''
    return 'all'
  else
    return ".#{DeloitteGame.Helpers.getColorFromPile(view)}"