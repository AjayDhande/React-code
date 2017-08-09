define ['jquery',
        'backbone',
        'collections/holiday/holiday',
        'templates/people/holiday'], ($,
        Backbone,
        HolidayCollection,
        template) ->
  class ShowTimeOffView extends Backbone.View
    initialize: ->
      @holidays = new HolidayCollection()
      @holidays.fetch(success: (response) =>
        @renderCalendar(@holidays)
        @bindRequestForm(@holidays))
      _.bindAll(@)

    bindRequestForm: (holidays) ->
      dateOpts =
        dateFormat: 'yy-mm-dd'
        changeMonth: true
        changeYear: true
      $('#new-request-form .datepicker').datepicker(dateOpts)
      $('#time_off_request_leave_start').change(@suggestion)
      $('#time_off_request_leave_end').change(@suggestion)

    suggestion: (e) ->
      start = $('#time_off_request_leave_start').val()
      end = $('#time_off_request_leave_end').val()
      startDate = @parseDate(start)
      currentDate = @parseDate(start)
      endDate = @parseDate(end)

      days = 0
      while (currentDate <= endDate)
        days = days + 1 unless (currentDate.getDay() % 6 == 0)
        current = currentDate.setDate(currentDate.getDate() + 1)
        currentDate = new Date(current)

      @holidays.each (holiday) =>
        date = new Date(holiday.get('year'), holiday.get('month') - 1, holiday.get('day'))
        days = days - 1 if days > 0 && date >= startDate && date <= endDate

      $('span.estimate').text(days)

    parseDate: (date) ->
      return new Date(0, 0, 0) unless date
      parts = date.split("-")
      new Date(parts[0], parseInt(parts[1]) - 1, parts[2])

    renderCalendar: (holidays) ->
      calendar = $('ul.holidays')
      holidays.each (holiday) =>
        calendar.append(template(holiday: holiday))
      @refreshCalendar((new Date()).getFullYear())
      $('.calendar-year .previous').click(@changeYear)
      $('.calendar-year .next').click(@changeYear)

    changeYear: (e) ->
      target = $(e.currentTarget)
      year = parseInt(target.parent().find('.current').text())
      if target.hasClass('next')
        year = year + 1
      else
        year = year - 1
      target.parent().find('.current').text(year)
      @refreshCalendar(year)

    refreshCalendar: (year) ->
      $('.holiday').each (index, holiday) =>
        $(holiday).hide()
        $(holiday).show() if $(holiday).data('year') == year
