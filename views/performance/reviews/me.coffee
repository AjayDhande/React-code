define ['jquery', 'underscore', 'backbone',
        'views/performance/reviews/search'], ($, _, Backbone
        ReviewsSearchView) ->
  class ReviewsMeView extends ReviewsSearchView
    type: 'reviewee'
    headers: [
      { name: 'Finalized By', attribute: 'employee_full_name', class: 'employee', sort: 'headerSortDown' },
      { name: 'Type', attribute: 'type', class: 'type', sort: 'headerSortUp' },
      { name: 'Label', attribute: 'review_group_title', class: 'label', sort: 'headerSortUp' },
      { name: 'Rating', attribute: 'rating_title', class: 'review-rating', sort: 'headerSortUp' },
      { name: 'Entry Date', attribute: 'entry_date', class: 'entry-date', sort: 'headerSortUp' },
      { name: '', attribute: 'actions', class: 'actions', sort: 'headerSortUp' }
    ]
