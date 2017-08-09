define ['views/goals/edit'], (GoalView) ->
  class TeamGoalView extends GoalView
    el: '.edit-team-goals'

    initialize: ->
      super()
      @toggleGoals('company-goals')

    tooltipPosition: ->
      {
        my: "left bottom+23",
        at: "right+15 bottom",
        collision: "none",
        using: (position, feedback) ->
          $(@).css(position)
          $("<div>").addClass("left-arrow").appendTo(@)
      }

    toggleGoals: (type) ->
      $(".goals .toggle-#{type}").click (e) =>
        target = $(e.target)
        toggle = target.parent()
        goals = toggle.parent().find(".#{type}")
        goals.toggle()
        if goals.is(':hidden')
          toggle.removeClass('close')
          toggle.addClass('close')
        else
          toggle.removeClass('close')
