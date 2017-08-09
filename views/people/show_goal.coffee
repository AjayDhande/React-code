define ['jquery', 'underscore', 'backbone', 'views/people/goal', 'tip'], ($, _, Backbone, GoalView) ->
  class ShowGoalView extends GoalView
    initialize: ->
      $(-> $().tip())
      @toggleGoals('show-form', 'company-goals')
      @toggleGoals('show-form', 'team-goals')
      @toggleGoals('show-form', 'personal-goals')
      @toggleGoals('show-form', 'subgoals')
