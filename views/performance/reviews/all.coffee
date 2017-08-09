define ['jquery', 'underscore', 'backbone',
        'views/performance/reviews/search'], ($, _, Backbone
        ReviewsSearchView) ->
  class ReviewsAllView extends ReviewsSearchView
    type: 'all'
    headers: [
      { name: 'Employee', attribute: 'employee_full_name', class: 'employee', sort: 'headerSortUp' },
      { name: 'Type', attribute: 'type', class: 'type', sort: 'headerSortUp' },
      { name: 'Label', attribute: 'review_group_title', class: 'label', sort: 'headerSortUp' },
      { name: 'Status', attribute: 'progress', class: 'review-progress', sort: 'headerSortUp' },
      { name: 'Due Date', attribute: 'due_date', class: 'due-date', sort: 'headerSortUp' },
      { name: '', attribute: 'actions', class: 'actions', sort: 'headerSortUp' }
    ]
