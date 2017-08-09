define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ToolPanelView extends Backbone.View
    initialize: ->
      @$el.off('click', '.button-tool')
      @$el.on('click', '.button-tool', _.bind(@toggle, @))
      @$el.parent().on 'toggle', (e, view, opening) =>
        if @open == true && view != @ && opening == true
          @open = false
          @$el.removeClass('tool-active')
      $(document).click (e) =>
        @toggle(e) if @open and $(e.target).parents('.tool-panel').length == 0

    toggle: (e) ->
      e.stopPropagation()
      @open = !@open
      @$el.parent().trigger('toggle', [@, @open])
      @$el.toggleClass('tool-active')
