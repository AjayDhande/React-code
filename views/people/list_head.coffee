define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->

  class ListHeadView extends Backbone.View
    nameClicked: 0
    $nameLink: null

    events:
      'click .order' : 'order'

    order: (e) ->
      e.preventDefault()
      $target = $(e.currentTarget)
      $parent = $target.parent()

      order_val = $target.data('order-value')
      if order_val == 'name'
        @$nameLink = $target
        # toggle between first and last name every 2 clicks
        if @nameClicked < 0
          order_val = 'first_name'
          order_title = '(First) Name'
        else
          order_val = 'last_name'
          order_title = '(Last) Name'
        @$nameLink.text(order_title)
        @nameClicked += 1
        @nameClicked = -2 if @nameClicked > 1
      else
        # reset
        @nameClicked = 0
        @$nameLink.text('Name') if @$nameLink

      if $parent.hasClass('desc')
        direction = 'asc'
      else
        direction = 'desc'

      $parent.parent().children().removeClass('asc').removeClass('desc')
      $parent.addClass(direction)
      @collection.order(order_val, direction)
      @trigger 'change'
