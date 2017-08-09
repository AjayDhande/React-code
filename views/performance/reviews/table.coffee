define ['jquery', 'underscore', 'backbone',
        'views/performance/reviews/row',
        'templates/performance/reviews/table'], ($, _, Backbone
        ReviewRowView,
        template) ->
  class ReviewsTableView extends Backbone.View
    el: '#reviews-table'
    empty: false
    events:
      'click .order': 'order'

    initialize: ->
      @collection.on('add', ((review) => @addRow(review)), @)
      @collection.on('reset', @render, @)

    addRows: (reviews) ->
      @$('.list_table_body').empty()
      _.each(reviews, (review) => @addRow(review))

    addRow: (review) ->
      view = new ReviewRowView(model: review, headers: @options.headers).render()
      @$('.list_table_body').append(view.el)

    render: ->
      @$el.html(template(headers: @options.headers))
      if @collection.length > 0
        @addRows(@collection.models)
      else
        @showEmpty()
      $('.loading').hide()
      @

    showEmpty: ->
      @$('.list_table').removeClass('with_row_action')
      @$('.list_table_body').append('<div id="empty_table">This table is currently empty.</div>')
      @$('#empty_table').show()
      @empty = true

    order: (e) ->
      return if @empty
      target = $(e.currentTarget)
      value = target.data('order-value')

      if target.hasClass('headerSortDown')
        target.removeClass('headerSortDown')
        target.addClass('headerSortUp')
      else
        target.removeClass('headerSortUp')
        target.addClass('headerSortDown')

      direction = 'desc'
      direction = 'asc' if target.hasClass('headerSortDown')
      @collection.order(value, direction).done =>
        @addRows(@collection.models)
        @setupInfiniteScroll()

    setupInfiniteScroll: ->
      scroll = new Backbone.InfiniScroll @collection,
        param: 'after'
        pageSizeParam: 'limit'
        pageSize: 10
        includePage: true
        success: (collection, response) =>
          $('.loading').hide()
          if response.reviews and response.reviews.length > 0
            scroll.fetchSuccess(collection, response.reviews)
        error: => $('.loading').hide()
        onFetch: => $('.loading').show()
        scrollOffset: 300
