define ['jquery', 'underscore', 'backbone',
        'views/reports/results',
        'views/reports/add_column',
        'views/reports/filter_panel',
        'views/reports/stats',
        'views/reports/saveas_panel', 'tip'], ($, _, Backbone,
        ReportResultsView, ReportAddColumn,
        ReportFilterPanelView, ReportStatsView, SaveasPanelView) ->
  class ReportShowView extends Backbone.View
    initialize: ->
      $( -> $().tip() )
      new ReportResultsView
        model: @model,

      new ReportAddColumn
        model: @model

      new ReportFilterPanelView(model: @model)

      new ReportStatsView(model: @model)
      new SaveasPanelView()
