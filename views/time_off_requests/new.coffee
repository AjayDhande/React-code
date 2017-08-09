define ['jquery', 'underscore', 'backbone', 'utils'], ($, _, Backbone, Utils) ->

  class TimeOffRequestCreate extends Backbone.View
    el: '#time_off_request_create'

    events:
      'change #time_off_request_leave_start': 'startDateChanged',
      'change #time_off_request_leave_end': 'startDateChanged',
      'keypress #time_off_request_days_off': 'validateDaysOff'

    dateOpts:
      dateFormat: 'yy-mm-dd'
      changeMonth: true
      changeYear: true

    spinnerOpts:
      min: 0
      max: 1000

    initialize: ->
      @$el.find('.date').datepicker(@dateOpts)
      @$el.find('.spinner').spinner(@spinnerOpts)

    startDateChanged: ->
      $start_date = @$("#time_off_request_leave_start")
      $end_date = @$("#time_off_request_leave_end")

      if (!$end_date.val())
        $end_date.val($start_date.val())

      $('#time_off_request_days_off').val(Utils.workingDaysBetweenDates($start_date.datepicker('getDate'), $end_date.datepicker('getDate')))

    validateDaysOff: (e) ->
      if (e.which!=8 && e.which!=0&& e.which!=46 && (e.which<48 || e.which>57))
        return false
