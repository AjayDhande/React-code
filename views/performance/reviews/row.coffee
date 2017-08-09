define ['jquery', 'underscore', 'backbone',
        'templates/performance/reviews/columns/employee',
        'templates/performance/reviews/columns/type',
        'templates/performance/reviews/columns/label',
        'templates/performance/reviews/columns/rating',
        'templates/performance/reviews/columns/progress',
        'templates/performance/reviews/columns/entry_date',
        'templates/performance/reviews/columns/due_date',
        'templates/performance/reviews/columns/actions'], ($, _, Backbone
        employeeTemplate,
        typeTemplate,
        labelTemplate,
        ratingTemplate,
        progressTemplate,
        entryDateTemplate,
        dueDateTemplate,
        actionsTemplate) ->
  class ReviewRowView extends Backbone.View
    tagName: 'ul'
    className: 'list_table_row'

    render: ->
      _.each @options.headers, (header) =>
        switch header.attribute
          when 'employee_full_name' then @$el.append(employeeTemplate(review: @model))
          when 'type' then @$el.append(typeTemplate(review: @model))
          when 'review_group_title' then @$el.append(labelTemplate(review: @model))
          when 'rating_title' then @$el.append(ratingTemplate(review: @model))
          when 'progress' then @$el.append(progressTemplate(review: @model))
          when 'entry_date' then @$el.append(entryDateTemplate(review: @model))
          when 'due_date' then @$el.append(dueDateTemplate(review: @model))
          when 'actions' then @$el.append(actionsTemplate(review: @model))
      @
