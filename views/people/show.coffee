define ['jquery',
        'backbone',
        'views/people/show_goal',
        'graph'], ($,
        Backbone,
        ShowGoalView) ->
  # We need the graph.js to load the graphs on the page.
  class PersonShowView extends Backbone.View
    initialize: ->
      new ShowGoalView
