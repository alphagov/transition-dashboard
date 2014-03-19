class Dashing.List extends Dashing.Widget
  @accessor 'org', Dashing.AnimatedValue
  @accessor 'status', Dashing.AnimatedValue
  @accessor 'rag', Dashing.AnimatedValue
  @accessor 'target', Dashing.AnimatedValue

  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()
