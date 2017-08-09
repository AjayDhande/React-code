define ['jquery', 'underscore', 'backbone',
        'views/performance/reviews/table',
        'views/performance/reviews/filter_panel'], ($, _, Backbone
        ReviewsTableView,
        ReviewsFilterPanelView) ->
  class ReviewsSearchView extends Backbone.View
    el: '#reviews_index'
    events: 'click .export': 'export'
    headers: []

    initialize: ->
      if @collection
        table = new ReviewsTableView(headers: @headers, collection: @collection)
        table.render()
        table.setupInfiniteScroll()
        @filter = new ReviewsFilterPanelView(collection: @collection)

    export: (e) ->
      document.location.href = "/performance/reviews/export.csv?#{@type}=true&#{$.param(@filter.serialized())}"
