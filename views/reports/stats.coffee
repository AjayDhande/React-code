define ['jquery', 'underscore', 'backbone',
        'templates/reports/stats'], ($, _, Backbone, template) ->
  class ReportStatsView extends Backbone.View
    el: '#result-count-holder'

    initialize: ->
      @model.on 'results', @render, @

    render: (results)->
      @$el.html(template(report: @model, results: results))
