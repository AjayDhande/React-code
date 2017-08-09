define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class GoalView extends Backbone.View
    toggleGoals: (form, type) ->
      $(".#{form} .goals .toggle-#{type}").click (e) =>
        target = $(e.target)
        toggle = target.parent()
        goals = toggle.parent().find(".#{type}")
        goals.toggle()
        if goals.is(':hidden')
          toggle.removeClass('close')
          toggle.addClass('close')
        else
          toggle.removeClass('close')
