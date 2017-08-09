define ['jquery',
        'underscore',
        'backbone',
        'utils',
        'views/components/tooltip'
        'nested_form'], ($, _, Backbone, Utils, TooltipView) ->
  class GoalView extends Backbone.View
    initialize: ->
      position = @tooltipPosition()
      _.each(@$el.find('a.tooltip'), (link) =>
        new TooltipView(el: $(link), position: position))

      Utils.setupDatePicker(@$el)

    tooltipPosition: ->
      {
        my: "right-15 bottom",
        at: "left bottom+23",
        collision: "none",
        using: (position, feedback) ->
          $(@).css(position)
          $("<div>").addClass("arrow").appendTo(@)
      }
