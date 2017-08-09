define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->

  class TimeOffRequestEditView extends Backbone.View
    el: '#time_off_request_edit'

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
