define ['jquery', 'underscore', 'backbone',
        'views/components/tool_panel',
        'templates/reports/add_column'], ($, _, Backbone,
        ToolPanelView, template) ->
  class ReportAddColumn extends ToolPanelView
    el: '#report-columns'
    events:
      'click .column': 'add'
      'keyup #input-column-field': 'search'

    initialize: ->
      super()
      @model.on 'sync', @render, @
      @$list = @$('#report-columns-list')
      $(window).resize _.bind(@resizeList, @)
      @resizeList()

    render: ->
      @$list.html template(columns: @columns())

    resizeList: ->
      size = $(window).height() - 450
      @$list.height(size) if size >= 200

    add: (e) ->
      name = $(e.currentTarget).data('value')
      @model.addColumns([name])
      column = _.find($('#report-columns-list .column'), (column) => $(column).data('value') == name)
      $(column).addClass('active')

    search: (e) ->
      @searchValue = e.currentTarget.value.toUpperCase()
      @render()

    columns: ->
      availableColumns = @model.get('available_columns')
      if @searchValue?
        cs = _.filter availableColumns, (c) => c.label.toUpperCase().indexOf(@searchValue) > -1
      else
        cs = availableColumns
      _.groupBy(cs, (c) -> c.category)

