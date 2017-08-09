define ['jquery', 'underscore', 'backbone'
        'templates/personal_calendar/subscribe_calendar'], ($, _, Backbone, subscribe_calendar) ->
  class SubscribeCalendarView extends Backbone.View

    events:
      'mousedown #subscribe_calendar_holder': 'onEvent'
      'click .generate-link': 'save'
      'click .unsync-events': 'remove'
      'click .cancel': 'removeSubscribeDiv'

    initialize: (e) ->
      @render()
      
    render: ->
      holidays_data = {slug: 'holidays', title: 'Holidays', type: 'holidays', scope:'all'}
      @.options.default_filters.unshift(holidays_data)
      section_second = @.options.default_filters
      if (section_second.length % 2) == 0
        divide_at = parseInt(section_second.length / 2)
      else
        divide_at = parseInt(section_second.length / 2) + 1
      section_first = section_second.splice(0, divide_at)
      @$el.html(subscribe_calendar(section_first: section_first, section_second: section_second, sync_cal_link: @.options.sync_cal_link, filter_data: @.options.filter_data, import_link: @.options.import_link))
      if @.options.filter_data
        $('.filter_data_info').removeClass('hidden')
        $('.subscribe_info').removeClass('hidden')
        $('.field').removeClass('hidden')
        $('.link_info').removeClass('hidden')
        $('.generate-link').text('Subscribe')
        $('.actions .cancel').text('Unsubscribe').addClass('unsync-events').removeClass('cancel')
        $('.desc').css('border-bottom', '1px solid #4f5962')
        filter_data = @.options.filter_data
        $("input:checkbox").each (index)->
          if $.inArray(@.value, filter_data) != -1
            $(".filters input[value='#{@.value}']").prop('checked', true)
      else
        $("input:checkbox").each (index)->
          $(".filters input[value='#{@.value}']").prop('checked', true)

    onEvent: (e) ->
      ele = $(e.currentTarget)
      ele.off('click', '.button-tool')
      ele.on('click', '.button-tool', _.bind(@toggle, @))
      ele.parent().on 'toggle', (e, view, opening) =>
        if @open == true && view != @ && opening == true
          @open = false
          ele.removeClass('tool-active')
      $(document).click (e) =>
        @toggle(e) if @open and $(e.target).parents('.tool-panel').length == 0

    toggle: (e) ->
      e.stopPropagation()
      @open = !@open
      $('#subscribe_calendar_holder').parent().trigger('toggle', [@, @open])
      $('#subscribe_calendar_holder').toggleClass('tool-active')

    save: (e) ->
      e.preventDefault()
      filters = []
      filters = $("input:checkbox:checked").map(->
                  @value
                ).get()
      @model.save({filter_data: filters},
        success: (resp)=>
          $('.tool-panel .field').removeClass('hidden')
          $('.subscribe_info').removeClass('hidden')
          $('.calendar-feed-link').val(resp.attributes.calendar_feed_link)
          $('.launch-link').attr('href', resp.attributes.calendar_feed_link)
          $('.google-calendar-link').attr('href', resp.attributes.import_link)
          $('.generate-link').text('Subscribe')
          $('.actions .cancel').text('Unsubscribe').addClass('unsync-events').removeClass('cancel')
          $('.link_info').removeClass('hidden')
          $('.desc').css('border-bottom', '1px solid #4f5962')
        )

    remove: (e) ->
      e.preventDefault()
      @model.destroy
        success: (resp) ->
          if resp
            window.location.reload true

    removeSubscribeDiv: ->
      $('#subscribe_calendar_holder').removeClass('tool-active')
