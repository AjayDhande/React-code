define ['jquery', 'underscore', 'backbone', 'overlay', 'fullcalendar',
        'templates/personal_calendar/filter_calendar_events',
        'templates/personal_calendar/tooltip',
        'templates/personal_calendar/event',
        'views/personal_calendar/subscribe_calendar',
        'models/icalendar_token'], ($, _, Backbone, OVLY, fullCalendar, filter_events_template,tooltip, event_template, SubscribeCalendarView, IcalendarTokenModel) ->

  class PersonalCalendarView extends Backbone.View
    el: '#personal_calendar'
    events:
      'mousedown .calendar_filters': 'onEvent'
      'click .calendar-filter': 'applyFilter'
      'click .events .prev_month': 'loadPrevMonth'
      'click .events .next_month': 'loadNextMonth'
      'click .fc-button-next span, .fc-button-prev span, .events .prev_month, .events .next_month': 'updateCalendarElements'

    initialize: ->
      @holidays = []
      @filters = []
      @filters_template = 'undefined'
      @currentRequest = null
      $(document).on("mouseenter", ".tooltipevent", @stopFadeOut)
      $(document).on("mouseleave", ".tooltipevent", @startFadeOut)
      window.refreshIntervalId = ''
      @active_filters = []
      @sync_info = ''

    onEvent: (e) ->
      $(".tooltipevent").remove()
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
      $('.calendar_filters').parent().trigger('toggle', [@, @open])
      $('.calendar_filters').toggleClass('tool-active')

    getStartDate: ->
      date = @$el.fullCalendar('getView').start
      $.datepicker.formatDate('yy-mm-dd', date);

    render: ->
      self = @
      $('.fc-header').remove()
      $('.fc-content').remove()
      if @parseQueryString()['month'] && @parseQueryString()['year'] && @parseQueryString()['filters[]']
        month = @parseQueryString()['month'][0]
        year = @parseQueryString()['year'][0]
        @active_filters = @parseQueryString()['filters[]']
      else
        date = new Date()
        month = date.getMonth()
        year = date.getFullYear()
        @active_filters = ["new_arrivals[all]", "birthdays[all]", "anniversaries[all]", "reviews_due[all]", "goals_target[all]", "time_off[all]"]

      @$el.fullCalendar
        header:
          left: ""
          center: "prev,title, next"
          right: ""
          ignoreTimezone: false

        disableDragging: true
        aspectRatio: 1.14
        weekMode: 'variable'
        buttonText:
          prev: ''
          next: ''
        month: month
        year: year
        eventSources: [
          events: (start, end, callback)=>
            $.ajax
              url: "/personal_calendar/events"
              method: 'GET'
              dataType: 'JSON'
              data:
                start_date: @getStartDate()
                filters: @active_filters
              success: (response) =>
                $('#personal_calendar').fullCalendar 'removeEvents'
                @holidays = response.holidays || []
                @filters = response.filters
                @updateTableEvents(response.events)
                @sync_info = response.sync_info
                events = []
                response_data = []
                $.each response, (key, val)->
                  response_data.push val
                events = events.concat.apply(events, response_data)
                callback events
          ignoreTimezone: false
        ]
        timeFormat: "h:mm t{ - h:mm t} "
        dragOpacity: "0.5"
        eventAfterRender: @eventAfterRender
        eventClick: @createTooltip
        dayClick: @removeTooltip
        eventMouseover: @applyColorAndBorder
        eventMouseout: @removeColorAndBorder
        loading: (bool) =>
          unless bool
            @holidays.forEach (obj) ->
              $("div.fc-day-number:contains("+obj.day+")").each ->
                unless $(@).parent().parent().hasClass('fc-other-month') && !$(@).is(":has(.holiday)")
                  if $(@).text() == obj.day
                    $(@).prepend(obj.desc)
            @createFilterDropdown()

    eventAfterRender: (event, element, view) ->
      element.find(".fc-event-inner").prepend event.icon
      element.find(".fc-event-title").html event.title
      if element.hasClass('fc-corner-left') && element.hasClass('time_off') && !element.hasClass('fc-corner-right')
        element.addClass('right-pointer')
        element.width(element.width()-10)
      else if element.hasClass('fc-corner-right') && element.hasClass('time_off') && !element.hasClass('fc-corner-left')
        element.addClass('left-pointer')
        element.css 'left', parseInt(element.css('left'))+10
        element.width(element.width()-10)
      else if !element.hasClass('fc-corner-right') && !element.hasClass('fc-corner-left') && element.hasClass('time_off')
        element.addClass('left-pointer').addClass('right-pointer')
        element.css 'left', parseInt(element.css('left'))+10
        element.width(element.width()-20)
      element.addClass(event.className+'_'+event.id)
      element.find('.fc-event-inner').css('width', element.width()-2)
      if element.hasClass('left-pointer')
        element.css('left', parseInt(element.css('left'))+1)
        element.css('width', element.width()-1)

    createFilterDropdown: ->
      if @filters_template == 'undefined'
        left_header = $('.fc-header').find('.fc-header-left')
        right_header = $('.fc-header').find('.fc-header-right')
        left_header.html(filter_events_template(filters: @filters))
        $.each @active_filters, (index, value) ->
          $('.calendar-filters').find("li[value='#{value}']").addClass('active')
        if $('#all_time_off').hasClass('active')
          $('#all_time_off').nextAll().addClass('active')
        icalendar_token = new IcalendarTokenModel()
        if @sync_info['icalendar_token_id']
          icalendar_token.set('id', @sync_info['icalendar_token_id'])
        if $('#use_calendar_sync').length
          new SubscribeCalendarView(el: right_header, sync_cal_link: @sync_info['sync_cal_link'], default_filters: @filters, filter_data: @sync_info['filter_data'], model: icalendar_token, import_link: @sync_info['import_link'])

    applyFilter: (e) ->
      ele = $(e.currentTarget)
      collection = ele.parent()
      if ele.hasClass('active')
        ele.removeClass('active')
      else
        ele.addClass('active')

      if ele.attr('id') == 'all_time_off'
        if ele.hasClass('active')
          ele.nextAll().addClass('active')
        else
          ele.nextAll().removeClass('active')
      if $('#all_time_off').nextAll().length == $('#all_time_off').nextAll('.active').length
        $('#all_time_off').addClass('active')
      else
        $('#all_time_off').removeClass('active')

      filters = []
      collection.find('li.calendar-filter.active').each (index)->
        filters.push($(@).attr('value'))

      @active_filters = filters
      @filters_template = collection.parent()
      @fetchEvents(filters)


    fetchEvents: (filters)=>
      @currentRequest = $.ajax
        url: "/personal_calendar/events"
        method: 'GET'
        dataType: 'JSON'
        context: @
        data:
          start_date: @getStartDate()
          filters: filters
        beforeSend: ->
          @currentRequest.abort() if @currentRequest?
        success: (response) ->
          events = []
          @updateTableEvents(response.events)
          response_data = []
          $.each response, (key, val)->
            response_data.push val
          events = events.concat.apply(events, response_data)
          $('#personal_calendar').fullCalendar 'removeEvents'
          $('#personal_calendar').fullCalendar 'addEventSource', events
          date = $('#personal_calendar').fullCalendar('getDate')
          params = $.param({ month: date.getMonth(), year: date.getFullYear(), filters: @active_filters })
          Backbone.history.navigate("/personal_calendar?"+params)

    createTooltip: (event, jsEvent) ->
      return unless $(jsEvent.target).hasClass('fc-event-title') || $(jsEvent.target).hasClass('ic')
      if $(".tooltipevent").data('event_id') == event.id && $(".tooltipevent").data('class_set') == $(jsEvent.currentTarget).attr('class')
        $(".tooltipevent").remove()
        if $(jsEvent.currentTarget).hasClass('time_off')
          $(jsEvent.currentTarget).css('border-color', '#c0e1a3')
          $(jsEvent.currentTarget).find('.fc-event-inner').css('border-color', '#c0e1a3')
        else
          $(jsEvent.currentTarget).addClass('white-border')
          $(jsEvent.currentTarget).find('.fc-event-inner').addClass('white-border')
        $(jsEvent.currentTarget).removeClass('left-pointer-border') if $(jsEvent.currentTarget).hasClass('left-pointer')
        $(jsEvent.currentTarget).removeClass('right-pointer-border') if $(jsEvent.currentTarget).hasClass('right-pointer')
        unless $(jsEvent.currentTarget).hasClass('time_off')
          $(jsEvent.currentTarget).find('.fc-event-inner').css('backgroundColor', '#ffffff').css('borderColor', '#ffffff')
          $(jsEvent.currentTarget).css('borderColor', '#ffffff')
        $(".tooltipevent").stop(true, true).fadeIn()
        return
      else
        $(".tooltipevent").remove()
      vertical_diff = $('.fc-view-month').offset().left + $('.fc-widget-content').width()*4
      horizontal_diff = $('.fc-week0').height()+$('.fc-week1').height()+$('.fc-week2').height()+$('.fc-week4').height()
      tooltip_data = tooltip((header: event.header, meta_data: event.meta_data, event_class: event.className, event: event))
      $("body").append tooltip_data
      $(".tooltipevent").data('event_id', event.id)

      $(@).css "z-index", 10000
      $(".tooltipevent").fadeIn("500").delay(3000).fadeOut('500')
      $(".tooltipevent").fadeTo "10", 1.9
      clearInterval(window.refreshIntervalId)
      window.refreshIntervalId = setInterval (->
          $('.fc-event').each ->
            if $(@).hasClass('time_off')
              $(@).css('border-color', '#c0e1a3')
              $(@).find('.fc-event-inner').css('border-color', '#c0e1a3')
              $(@).removeClass('left-pointer-border') if $(@).hasClass('left-pointer')
              $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')
            else
              $(@).addClass('white-border')
              $(@).find('.fc-event-inner').addClass('white-bg').addClass('white-border')
        ), 3000

      if jsEvent.pageX > vertical_diff
        $(".tooltipevent").css "left", parseInt($(jsEvent.currentTarget).css('left')) + $('.fc-view-month').offset().left - $('.tooltipevent').width() - 30
        $('.tooltip-arrow').addClass 'r-arrow'
        unless $('.tooltipevent .content').hasClass('new_arrival') || $('.tooltipevent .content').hasClass('birthday')
          $('.r-arrow').css 'left', 301
      else
        $(".tooltipevent").css "left", parseInt($(jsEvent.currentTarget).css('left')) + $('.fc-view-month').offset().left + $('.fc-widget-content').width() + 10
        $('.tooltip-arrow').addClass 'l-arrow'

      if $(jsEvent.currentTarget).hasClass('left-pointer')
        $(".tooltipevent").css "left", parseInt($(".tooltipevent").css('left')) - 10

      if jsEvent.currentTarget.offsetTop < horizontal_diff
        $(".tooltipevent").css "top", $('.fc-view-month').offset().top + jsEvent.currentTarget.offsetTop - 55
        $('.tooltip-arrow').css 'top', 55
      else
        $(".tooltipevent").css "top", $('.fc-view-month').offset().top + jsEvent.currentTarget.offsetTop - $('.tooltipevent').height() + 25
        $('.tooltip-arrow').css 'bottom', 25

      $(jsEvent.currentTarget).removeClass('white-border')
      $(jsEvent.currentTarget).css('border-top-width', '1px').css('border-bottom-width', '1px')
      $(jsEvent.currentTarget).find('.fc-event-inner').removeClass('white-border').removeClass('white-bg')
      switch event.className[0]
        when 'reviews_due'
          $(jsEvent.currentTarget).find('.fc-event-inner').css('backgroundColor', '#dec2e5').css('borderColor', '#6f3b7e')
          $(jsEvent.currentTarget).css('borderColor', '#6f3b7e')
        when 'anniversary'
          $(jsEvent.currentTarget).find('.fc-event-inner').css('backgroundColor', '#fee5b7').css('borderColor', '#d3a043')
          $(jsEvent.currentTarget).css('borderColor', '#d3a043')
        when 'birthday'
          $(jsEvent.currentTarget).find('.fc-event-inner').css('backgroundColor', '#c9e1f7').css('borderColor', '#4c9be6')
          $(jsEvent.currentTarget).css('borderColor', '#4c9be6')
        when 'goals_target'
          $(jsEvent.currentTarget).find('.fc-event-inner').css('backgroundColor', '#a3e9ed').css('borderColor', '#129fa5')
          $(jsEvent.currentTarget).css('borderColor', '#129fa5')
        when 'new_arrival'
          $(jsEvent.currentTarget).find('.fc-event-inner').css('backgroundColor', '#f5c3aa').css('borderColor', '#b85828')
          $(jsEvent.currentTarget).css('borderColor', '#b85828')
        when 'time_off'
          $(jsEvent.currentTarget).find('.fc-event-inner').css('borderColor', '#36660a')
          $(jsEvent.currentTarget).css('borderColor', '#36660a')
          $(jsEvent.currentTarget).addClass('left-pointer-border') if $(jsEvent.currentTarget).hasClass('left-pointer')
          $(jsEvent.currentTarget).addClass('right-pointer-border') if $(jsEvent.currentTarget).hasClass('right-pointer')

      $('.fc-event').each ->
        unless $(@).css('left') == $(jsEvent.currentTarget).css('left') && $(@).css('top') == $(jsEvent.currentTarget).css('top')
          if $(@).hasClass('time_off')
            $(@).css('border-color', '#c0e1a3')
            $(@).find('.fc-event-inner').css('border-color', '#c0e1a3')
            $(@).removeClass('left-pointer-border') if $(@).hasClass('left-pointer')
            $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')
          else
            $(@).addClass('white-border')
            $(@).find('.fc-event-inner').addClass('white-bg').addClass('white-border')
      $(".tooltipevent").data('class_set', $(jsEvent.currentTarget).attr('class'))

    removeTooltip: (event, jsEvent) ->
      $(@).css "z-index", 8
      $(".tooltipevent").remove()
      $('.fc-event').each ->
        unless $(@).css('left') == $(jsEvent.currentTarget).css('left') && $(@).css('top') == $(jsEvent.currentTarget).css('top')
          if $(@).hasClass('time_off')
            $(@).css('border-color', '#c0e1a3')
            $(@).find('.fc-event-inner').css('border-color', '#c0e1a3')
            $(@).removeClass('left-pointer-border') if $(@).hasClass('left-pointer')
            $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')
          else
            $(@).addClass('white-border')
            $(@).find('.fc-event-inner').addClass('white-bg').addClass('white-border')

    loadPrevMonth: ->
      $(".tooltipevent").remove()
      @$el.fullCalendar 'prev'

    loadNextMonth: ->
      $(".tooltipevent").remove()
      @$el.fullCalendar 'next'

    updateCalendarElements: ->
      $(".tooltipevent").remove()
      $('.table-structure .events').html('')
      date = $('#personal_calendar').fullCalendar('getDate')
      params = $.param({ month: date.getMonth(), year: date.getFullYear(), filters: @active_filters })
      Backbone.history.navigate("/personal_calendar?"+params)

    updateTableEvents: (events)->
      $('.events').html(event_template(prev_month: events.prev_month_title, next_month: events.next_month_title, events: events.events))
      if events.length == 0
        $('.table-structure .header').hide()
      else
        $('.table-structure .header').show()


    stopFadeOut: (e)->
      $(e.currentTarget).stop(true, true).fadeIn()
      clearInterval(window.refreshIntervalId)

    startFadeOut: (e)->
      $(e.currentTarget).delay(3000).fadeOut('500')
      window.refreshIntervalId = setInterval (->
          $('.fc-event').each ->
            if $(@).hasClass('time_off')
              $(@).css('border-color', '#c0e1a3')
              $(@).find('.fc-event-inner').css('border-color', '#c0e1a3')
              $(@).removeClass('left-pointer-border') if $(@).hasClass('left-pointer')
              $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')
            else
              $(@).addClass('white-border')
              $(@).find('.fc-event-inner').addClass('white-bg').addClass('white-border')
        ), 3000

    applyColorAndBorder: (event, jsEvent, view)->
      if $(jsEvent.currentTarget).hasClass('time_off')
        element = $('.'+event.className[0]+'_'+event.id)
        element.removeClass('white-border')
        element.find('.fc-event-inner').removeClass('white-border')
        element.find('.fc-event-inner').css('borderColor', event.textColor)
        element.css('borderColor', event.textColor)
        element.find('.fc-event-inner').css('color', '#36660a')
        element.each ->
          if $(@).hasClass('left-pointer')
            $(@).addClass('left-pointer-border')
          $(@).addClass('right-pointer-border') if $(@).hasClass('right-pointer')

    removeColorAndBorder: (event, jsEvent, view)->
      if $(jsEvent.currentTarget).hasClass('time_off')
        element = $('.'+event.className[0]+'_'+event.id)
        element.removeClass('white-border')
        element.find('.fc-event-inner').removeClass('white-border')
        element.find('.fc-event-inner').css('color', event.textColor)
        element.find('.fc-event-inner').css('borderColor', event.color)
        element.css('borderColor', event.color)
        element.each ->
          if $(@).hasClass('left-pointer')
            $(@).removeClass('left-pointer-border')
          $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')

    parseQueryString: ->
      map = undefined
      query = undefined
      query = decodeURIComponent((window.location.search or "?").substr(1))
      map = {}
      query.replace /([^&=]+)=?([^&]*)(?:&+|$)/g, (match, key, value) ->
        (map[key] = map[key] or []).push value
      map