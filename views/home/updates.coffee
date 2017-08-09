define ['backbone',
        'moment',
        'templates/event/day_block',
        'templates/event/block',
        'tip'], (Backbone, moment,
        dayBlockTemplate, blockTemplate) ->
  class UpdatesView extends Backbone.View
    el: '#updates'
    events:
      'click .delete-update': 'deleteAnnouncement'

    initialize: (options) ->
      _.bindAll(@)
      @collection.on('add', @add, @)
      @collection.on('reset', @reset, @)
      @collection.fetch
        update: true
        success: @loadSuccess
        error: @loadError

      @infiniScroll = new Backbone.InfiniScroll @collection,
        param: 'after'
        pageSizeParam: 'limit'
        pageSize: 30,
        success: @loadSuccess
        onFetch: => $('#home-loading').show()
        error: @loadError
        scrollOffset: 300

    loadSuccess: (collection, response) ->
      $('#home-loading').hide()
      if @collection.length == 0
        $('#updates-empty').removeClass('ui-helper-hidden')

    loadError: (collection, response) ->
      $('#home-loading').hide()

    getDateString: (date) ->
      "#{date.getFullYear()}#{("0" + date.getMonth()).slice(-2)}#{("0" + date.getDate()).slice(-2)}"

    getOrCreateDayBlock: (date) ->
      id = "update-#{@getDateString(date)}"
      $block = @$("##{id}")
      unless $block.length
        $block = $(dayBlockTemplate({id: id, date: moment(date).format("dddd, MMMM D YYYY")})).appendTo(@$el)
      $block.find('.events')

    add: (event) ->
      $dayBlock = @getOrCreateDayBlock(event.get('created_at'))
      $dayBlock.append($(blockTemplate({event: event})))

    reset: ->
      @$el.empty()
      @collection.each (event) =>
        @add(event)

    deleteAnnouncement: (e) ->
      if window.confirm("Are you sure you want to delete this update?")
        new @options.updates.model(id: $(e.currentTarget).data('update-id')).destroy
          success: =>
            @collection.fetch(reset: true)

