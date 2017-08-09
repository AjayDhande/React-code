define ['jquery', 'underscore', 'backbone',
        'views/performance/pending_tasks/row',
        'templates/performance/pending_tasks/table'], ($, _, Backbone
        PendingTasksRowView,
        template) ->
  class ReviewPendingTasksTableView extends Backbone.View
    events:
      'click .list_table_head a': 'order'

    addRows: (tasks) ->
      _.each tasks, (task) =>
        view = new PendingTasksRowView(model: task).render()
        @$('.list_table_body').append(view.el)

    render: ->
      @$el.html(template(title: @options.title))
      if @collection.length > 0
        @addRows(@collection)
      else
        @showEmpty()
      @

    order: (e) ->
      target = $(e.currentTarget)
      value = target.data('order-value')
      tasks = _.sortBy(@collection, (model) -> model.get(value))

      if target.hasClass('headerSortDown')
        tasks.reverse()
        target.removeClass('headerSortDown')
        target.addClass('headerSortUp')
      else
        target.removeClass('headerSortUp')
        target.addClass('headerSortDown')

      @$('.list_table_body').empty()
      @addRows(tasks)
