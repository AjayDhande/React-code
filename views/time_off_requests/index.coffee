define ['jquery', 'underscore', 'backbone', 'overlay', 'fullcalendar',
        'templates/time_off/table',
        'templates/personal_calendar/tooltip',
        'templates/time_off/request/form'], ($, _, Backbone, OVLY, fullCalendar, table_template, approved_tooltip, request_form) ->

  class TimeOffRequestView extends Backbone.View
    el: '.time_off_requests-index'
    events:
      'click .events .prev_month': 'loadPrevMonth'
      'click .events .next_month': 'loadNextMonth'
      'click #time-off-filter a': 'fetchData'
      'click .fc-button-next span, .fc-button-prev span, .events .prev_month, .events .next_month': 'updateCalendarElements'
      "submit .edit_time_off_request": "updateTimeOffRequest"

    initialize: ->
      @holidays = []
      @active_tab = 'all'

    render: ->
      self = @
      $('.fc-header').remove()
      $('.fc-content').remove()
      if @getParameterByName('month') && @getParameterByName('year')
        month = @getParameterByName('month')
        year = @getParameterByName('year')
      else
        date = new Date()
        month = date.getMonth()
        year = date.getFullYear()
      if @getParameterByName('filter')
        @active_tab = @getParameterByName('filter')
        $('#time-off-filter a').removeClass('on')
        $('#time-off-filter').find('a#'+@active_tab).addClass('on')
      $('#calendar').fullCalendar
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
          events: (start, end, callback)->
            $.ajax
              url: "/time_off_requests/calendar_data"
              method: 'GET'
              dataType: 'JSON'
              data:
                start: Math.round(start.getTime() / 1000)
                end: Math.round(end.getTime() / 1000)
                start_date: $('#calendar').fullCalendar('getView').start
                filter: self.active_tab
              success: (response) ->
                $('#calendar').fullCalendar 'removeEvents'
                self.holidays = response.holidays
                self.updateTable(response.requests, response.prev_month, response.next_month)
                callback response.requests
          ignoreTimezone: false
        ]
        timeFormat: "h:mm t{ - h:mm t} "
        dragOpacity: "0.5"
        eventAfterRender: @eventAfterRender
        eventClick: @createTooltip
        dayClick: @removeTooltip
        eventMouseover: @applyColorAndBorder
        eventMouseout: @removeColorAndBorder
        loading: (bool) ->
          unless bool
            self.holidays.forEach (obj) ->
              $("div.fc-day-number:contains("+obj.day+")").each ->
                unless $(@).parent().parent().hasClass('fc-other-month') && !$(@).is(":has(.holiday)")
                  if $(@).text() == obj.day
                    $(@).prepend(obj.desc)

    eventAfterRender: (event, element, view) ->
      element.find(".fc-event-inner").prepend event.icon
      element.find(".fc-event-title").html event.title
      element.addClass(event.className[0]+'_'+event.id)
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
      element.find('.fc-event-inner').css 'width', element.width() - 2
      if element.hasClass('left-pointer')
        element.css('left', parseInt(element.css('left'))+1)
        element.css('width', element.width()-1)

    updateTable: (requests, prev_month, next_month)->
      $('.events').html(table_template(prev_month: prev_month, next_month: next_month, requests: requests, scope: @active_tab))
      if requests.length == 0
        $('.table-structure .table_header').hide()
      else
        $('.table-structure .table_header').show()
      @updateTableStructureAndLegend(@active_tab)

    loadPrevMonth: ->
      $('#calendar').fullCalendar 'prev'

    loadNextMonth: ->
      $('#calendar').fullCalendar 'next'

    fetchData: (e)->
      e.preventDefault()
      ele = $(e.currentTarget)
      collection = ele.parent()
      collection.find('a').removeClass('on')
      ele.addClass('on')
      scope = ele.attr('id')
      @active_tab = scope
      $.ajax
        url: "/time_off_requests/calendar_data"
        method: 'GET'
        dataType: 'JSON'
        context: @
        data:
          start_date: $('#calendar').fullCalendar('getView').start
          filter: scope
        success: (response) ->
          $('#calendar').fullCalendar 'removeEvents'
          $('#calendar').fullCalendar 'addEventSource', response.requests
          @updateTable(response.requests, response.prev_month, response.next_month)
          date = $('#calendar').fullCalendar('getDate')
          Backbone.history.navigate("/time_off_requests?month="+date.getMonth()+"&year="+date.getFullYear()+"&filter="+@active_tab)

    createTooltip: (event, jsEvent) ->
      return unless $(jsEvent.target).hasClass('fc-event-title') || $(jsEvent.target).hasClass('ic')
      $(".tooltipevent").remove()
      vertical_diff = $('.fc-view-month').offset().left + $('.fc-widget-content').width()*4
      horizontal_diff = $('.fc-week0').height()+$('.fc-week1').height()+$('.fc-week2').height()+$('.fc-week4').height()
      if event.className[1] == 'pending'
        html = request_form(request: event)
        OVLY.show(html, true, 800, 592, {classMod: "pending-time-off"})
      else
        tooltip_data = approved_tooltip((header: event.header, meta_data: event.meta_data, event_class: event.className, event: event))
        $("body").append tooltip_data

        $(@).css "z-index", 10000
        $(".tooltipevent").fadeIn "500"
        $(".tooltipevent").fadeTo "10", 1.9

        if jsEvent.pageX > vertical_diff
          $(".tooltipevent").css "left", parseInt($(jsEvent.currentTarget).css('left')) + $('.fc-view-month').offset().left - $('.tooltipevent').width() - 30
          $('.tooltip-arrow').addClass 'r-arrow'
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
          $(".tooltipevent").css "top", $('.fc-view-month').offset().top + jsEvent.currentTarget.offsetTop - 61
          $('.tooltip-arrow').css 'bottom', 25

        $(jsEvent.currentTarget).removeClass('white-border')
        $(jsEvent.currentTarget).css('border-top-width', '1px').css('border-bottom-width', '1px')
        $(jsEvent.currentTarget).find('.fc-event-inner').removeClass('white-border').removeClass('white-bg')
        $(jsEvent.currentTarget).find('.fc-event-inner').css('borderColor', '#36660a')
        $(jsEvent.currentTarget).css('borderColor', '#36660a')
        $(jsEvent.currentTarget).addClass('left-pointer-border') if $(jsEvent.currentTarget).hasClass('left-pointer')
        $(jsEvent.currentTarget).addClass('right-pointer-border') if $(jsEvent.currentTarget).hasClass('right-pointer')

        $('.fc-event').each ->
          unless $(@).css('left') == $(jsEvent.currentTarget).css('left') && $(@).css('top') == $(jsEvent.currentTarget).css('top')
            if $(@).hasClass('pending')
              $(@).css('border-color', '#fee5b7')
              $(@).find('.fc-event-inner').css('border-color', '#fee5b7')
            else
              $(@).css('border-color', '#c0e1a3')
              $(@).find('.fc-event-inner').css('border-color', '#c0e1a3')
            $(@).removeClass('left-pointer-border') if $(@).hasClass('left-pointer')
            $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')

    updateCalendarElements: ->
      $(".tooltipevent").remove()
      $('.table-structure .events').html('')
      date = $('#calendar').fullCalendar('getDate')
      filter = $('#time-off-filter').find('a.on').attr('id')
      Backbone.history.navigate("/time_off_requests?month="+date.getMonth()+"&year="+date.getFullYear()+"&filter="+filter)
      @updateTableStructureAndLegend(@active_tab)

    removeTooltip: (event, jsEvent) ->
      $(@).css "z-index", 8
      $(".tooltipevent").remove()
      $('.fc-event').each ->
        unless $(@).css('left') == $(jsEvent.currentTarget).css('left') && $(@).css('top') == $(jsEvent.currentTarget).css('top')
          if $(@).hasClass('pending')
            $(@).css('border-color', '#fee5b7')
            $(@).find('.fc-event-inner').css('border-color', '#fee5b7')
          else
            $(@).css('border-color', '#c0e1a3')
            $(@).find('.fc-event-inner').css('border-color', '#c0e1a3')
          $(@).removeClass('left-pointer-border') if $(@).hasClass('left-pointer')
          $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')

    updateTableStructureAndLegend: (scope)->
      if scope == 'pending' || scope == 'approved'
        $('#calendar .legend').css('display', 'none')
        $('ul.table_header').removeClass('pending').removeClass('approved').addClass(scope)
        $('ul.table_row').removeClass('pending').removeClass('approved').addClass(scope)
      else
        $('#calendar .legend').css('display', 'block')
        $('ul.table_header').removeClass('pending').removeClass('approved')
        $('ul.table_row').removeClass('pending').removeClass('approved')

    applyColorAndBorder: (event, jsEvent, view)->
      if $(jsEvent.currentTarget).hasClass('approved')
        color = '#36660a'
      else
        color = '#9b7531'
      element = $('.'+event.className[0]+'_'+event.id)
      element.removeClass('white-border')
      element.find('.fc-event-inner').css('color', color)
      element.find('.fc-event-inner').css('borderColor', color)
      element.css('borderColor', color)
      element.each ->
        if $(@).hasClass('left-pointer')
          $(@).addClass('left-pointer-border')
        $(@).addClass('right-pointer-border') if $(@).hasClass('right-pointer')

    removeColorAndBorder: (event, jsEvent, view)->
      if $(jsEvent.currentTarget).hasClass('approved')
        color = '#4a8c0f'
        borderColor = '#c0e1a3'
      else
        color = '#d3a043'
        borderColor = '#fee5b7'
      element = $('.'+event.className[0]+'_'+event.id)
      element.removeClass('white-border')
      element.find('.fc-event-inner').removeClass('white-border')
      element.find('.fc-event-inner').css('color', color)
      element.find('.fc-event-inner').css('borderColor', borderColor)
      element.css('borderColor', borderColor)
      element.each ->
        if $(@).hasClass('left-pointer')
          $(@).removeClass('left-pointer-border')
        $(@).removeClass('right-pointer-border') if $(@).hasClass('right-pointer')

    updateTimeOffRequest: (e)->
      e.preventDefault()
      selected = $("input[type='radio'][name='time_off_request_approved']:checked")
      param = {'manager_notes': $('#time_off_request_manager_notes').val(), 'approved': selected.val()}
      serialized = _.object(_.map($('.edit_time_off_request').serializeArray(), (element) ->
        [element.name, element.value]))
      action = $('.edit_time_off_request').attr('action')
      serialized.time_off_request = param
      $.ajax
        url : action
        data : JSON.stringify(serialized)
        type : 'PATCH'
        contentType : 'application/json'
        dataType: 'json'
        success: (retdata) ->
          if retdata.success
            window.location.reload true

    getParameterByName: (name)->
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
      regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
      results = regex.exec(location.search)
      (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))