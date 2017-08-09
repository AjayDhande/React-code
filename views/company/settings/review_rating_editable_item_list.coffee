define ['jquery', 'underscore', 'backbone',
        'views/components/editable_item_list'], ($, _, Backbone,
        EditableItemListView) ->
  class ReviewRatingEditableItemListView extends EditableItemListView

    initialize: (options)->
      super(options)
      @$items.sortable
        axis: "y"
        opacity: .6
        forceHelperSize: true
        stop: _.bind(@onOrder, @)

    onOrder: (e)->
      $.ajax(
        url: '/performance_review_ratings/update-order'
        data: @$items.sortable("serialize")
      )
