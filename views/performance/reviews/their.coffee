define ['jquery', 'underscore', 'backbone',
        'views/performance/reviews/search'], ($, _, Backbone
        ReviewsSearchView) ->
  class ReviewsTheirView extends ReviewsSearchView
    type: 'report_to'
    headers: [
      { name: 'Employee', attribute: 'employee_full_name', class: 'employee', sort: 'headerSortDown' },
      { name: 'Type', attribute: 'type', class: 'type', sort: 'headerSortUp' },
      { name: 'Label', attribute: 'review_group_title', class: 'label', sort: 'headerSortUp' },
      { name: 'Status', attribute: 'progress', class: 'review-progress', sort: 'headerSortUp' },
      { name: 'Due Date', attribute: 'due_date', class: 'due-date', sort: 'headerSortUp' },
      { name: '', attribute: 'actions', class: 'actions', sort: 'headerSortUp' }
    ]
