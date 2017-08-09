define ['jquery', 'underscore', 'backbone', 'templates/people/subgoal'], ($, _, Backbone, template) ->
  class SubgoalView extends Backbone.View
    render: ->
      @$el.html(template(
        prefix: @options.prefix,
        name: @options.name,
        id: @options.id,
        title: @options.title
      ))
      @
