define ['jquery', 'underscore', 'backbone',
        'templates/performance/pending_tasks/row'], ($, _, Backbone
        template) ->
  class ReviewPendingTasksRowView extends Backbone.View
    tagName: 'ul'
    className: 'list_table_row'

    render: ->
      @$el.html(template(task: @model))
      @
