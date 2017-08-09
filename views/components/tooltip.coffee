define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class TooltipView extends Backbone.View
    initialize: ->
      @createTooltip()
      @$el.data('tooltip-open', false)
      @$el.tooltip('option', 'disabled', true)
      @$el.tooltip().click((event) =>
        event.stopImmediatePropagation()
        @closeAllTooltips()
        unless @$el.data('tooltip-open')
          @createTooltip()
          @$el.data('tooltip-open', true)
          @$el.tooltip('open'))
      $(document).click((event) => @closeAllTooltips())

    defaultPosition: -> {
      my: "right-15 bottom",
      at: "left bottom+23",
      collision: "none",
      using: (position, feedback) ->
        $(@).css(position)
        $("<div>").addClass("arrow").appendTo(@)
    }

    createTooltip: ->
      position = @options.position || @defaultPosition()
      @$el.tooltip()
      @$el.tooltip("option", "hide", {duration: 100} )
      @$el.tooltip("option", "position", position)
      @$el.tooltip("option", "content", @$el.data('content'))
      @$el.tooltip('option', 'disabled', false)
      @$el.mouseleave((event) -> event.stopImmediatePropagation())

    closeAllTooltips: ->
      _.each($('a.tooltip'), (link) =>
        if $(link).data('tooltip-open')
          $(link).data('tooltip-open', false)
          $(link).tooltip('destroy'))
