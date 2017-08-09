define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class AccountExportView extends Backbone.View
    el: '#team-holder'
    dateOpts:
      dateFormat:'yy-mm-dd'
      changeMonth:true
      changeYear:true

    initialize: ->
      @$el.find('.date_picker').datepicker(@dateOpts);
