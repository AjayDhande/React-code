define ['jquery', 'underscore', 'backbone',
        'templates/reports/filter_list'], ($, _, Backbone, template) ->
  class ReportFilterListView extends Backbone.View
    el: '#filter_list'

    events:
      'click .delete': 'removeFilter'

    initialize: ->
      @model.on 'sync', @render, @

    render: ->
      @$el.html(template(report: @model))

    removeFilter: (e) ->
      e.preventDefault()
      @model.removeFilterIndex($(e.currentTarget).data('filter_index'))

