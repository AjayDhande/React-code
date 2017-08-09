define ['jquery', 'underscore', 'backbone',
        'templates/system_log/day_block',
        'templates/system_log/block', 'moment'], ($, _, Backbone,
        dayBlockTemplate,
        blockTemplate) ->
  class SystemLogView extends Backbone.View
    el: '#system_logs'
    events: 
      "click .title": "titleClick"
    initialize: ->
      _.bindAll(@)
      @collection.on('add', _.bind(@add, @))
      @collection.fetch
        update: true
        success: @loadSuccess
        error: @loadError

      @infiniScroll = new Backbone.InfiniScroll @collection,
        param: 'after'
        pageSizeParam: 'limit'
        pageSize: 30,
        success: @loadSuccess
        onFetch: => $('#system_logs-loading').show()
        error: @loadError
        scrollOffset: 300

    loadSuccess: (collection, response) ->
      $('#system_logs-loading').hide()
      if @collection.length == 0
        $('#system_logs-empty').removeClass('ui-helper-hidden')

    loadError: (collection, response) ->
      $('#system_logs-loading').hide()

    getDateString: (date) ->
      "#{date.getFullYear()}#{("0" + date.getMonth()).slice(-2)}#{("0" + date.getDate()).slice(-2)}"

    getOrCreateDayBlock: (date) ->
      id = "system_logs-#{@getDateString(date)}"
      $block = @$("##{id}")
      unless $block.length
        $block = $(dayBlockTemplate({id: id, date: date})).appendTo(@$el)
      $block.find('.system_logs')

    add: (system_log) ->
      $dayBlock = @getOrCreateDayBlock(system_log.get('created_at'))
      $dayBlock.append($(blockTemplate({system_log: system_log})))

    titleClick: (e) ->
      e.preventDefault()
      $target = $(e.currentTarget).parent()
      $target.find('.icon').toggleClass('open')
      $target.find('.details').toggle()

