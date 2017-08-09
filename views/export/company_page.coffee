define ['jquery', 'underscore', 'backbone',
        'views/export/base'], ($, _, Backbone, ExportBaseView) ->
  class ExportCompanyPageView extends ExportBaseView
    el: '#team-holder'
    dateOpts:
      dateFormat:'yy-mm-dd'
      changeMonth:true
      changeYear:true

    initialize: ->
      @$el.find('.date_picker').datepicker(@dateOpts);
