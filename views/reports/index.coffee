define ['jquery', 'underscore', 'backbone', 'jquery.tablesorter'], ($, _, Backbone) ->
  class ReportShowView extends Backbone.View
    el: '#reports-table'
    initialize: ->
      $( => @$el.tablesorter(sortList: [[3,0]]) )
