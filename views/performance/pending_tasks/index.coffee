define ['jquery', 'underscore', 'backbone',
        'views/performance/pending_tasks/table',
        'templates/performance/pending_tasks/index'], ($, _, Backbone
        PendingTasksTableView,
        template) ->
  class ReviewPendingTasksIndexView extends Backbone.View
    el: '#performance_home'

    render: ->
      @$el.html(template())
      @tasks = @collection.groupBy((task) -> task.get('state'))
      new PendingTasksTableView(el: @$('#to_write'), collection: @tasks.to_write, title: 'Reviews to Write').render() if @tasks.to_write
      new PendingTasksTableView(el: @$('#to_approve'), collection: @tasks.to_approve, title: 'Reviews to Approve').render() if @tasks.to_approve
      new PendingTasksTableView(el: @$('#to_finalize'), collection: @tasks.to_finalize, title: 'Reviews to Finalize').render() if @tasks.to_finalize
      new PendingTasksTableView(el: @$('#to_sign'), collection: @tasks.to_sign, title: 'Reviews to Sign').render() if @tasks.to_sign
      new PendingTasksTableView(el: @$('#to_assign'), collection: @tasks.to_assign, title: 'Reviews to Assign').render() if @tasks.to_assign
      unless @tasks.to_assign || @tasks.to_sign || @tasks.to_finalize || @tasks.to_approve || @tasks.to_write
        $('#performance_description').hide()
        @$('#empty_table').show()
