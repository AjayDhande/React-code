define ['jquery', 'underscore', 'backbone', 'slickgrid',
        'templates/reports/results', 'slickgridHeaderButtons'], ($, _, Backbone,
        Slick, template) ->
  class ReportResultsView extends Backbone.View
    el: '#results'
    events:
      'click .remove': 'removeColumn'

    initialize: ->
      @model.on('sync', @render, @)
      $(window).resize _.bind(@resize, @)
      @resize()

    resize: ->
      size = $(window).height() - 340
      @$el.height(size) if size >= 340
      if @grid?
        @grid.resizeCanvas();

    render: ->
      @$el.css(backgroundColor: '#eee')
      @model.results(true).done (results) =>
        names = results.columns.map (column) -> column.name
        for column in $('#report-columns-list .column')
          $(column).addClass('active') if _.contains(names, $(column).data('value'))

        @$el.animate(backgroundColor: 'transparent', 100)
        data = @remapResults(results)
        @grid = new Slick.Grid(@el, data, @remapColumns(results.columns), {
          rowHeight: 30,
          enableTextSelectionOnCells: true,
          forceFitColumns: true
        });
        headerButtonsPlugin = new Slick.Plugins.HeaderButtons()
        @grid.registerPlugin(headerButtonsPlugin)
        @grid.onSort.subscribe (e, args) =>
          field = args.sortCol.field

          data.sort (rowA, rowB)->
            a = rowA[field]
            b = rowB[field]
            asc = if args.sortAsc then true else false

            if a == null and b == null then return 0
            if a == null then return 1
            if b == null then return -1

            result = a - b

            if isNaN(result)
              if asc
                a.toString().localeCompare(b)
              else
                b.toString().localeCompare(a)
            else
              if asc
                result
              else
                -result

          @grid.invalidate()
          @grid.render()
        @grid.onColumnsReordered.subscribe (e, args) =>
          columnIds = _.pluck(args.grid.getColumns(), 'field')
          @model.set('columns', columnIds)
          @model.save()
      @

    onResize: ->
      @setTableWidth()

    removeColumn: (e)->
      e.preventDefault()
      index = @$('.slick-header-columns').children().index($(e.currentTarget).parent())
      name = @model.get('columns')[index].name
      @model.removeColumnIndex(index)
      column = _.find($('#report-columns-list .column'), (column) => $(column).data('value') == name)
      $(column).removeClass('active')

    remapColumns: (columns) ->
      {
        id: column.name
        name: column.label
        field: column.name
        sortable: true
        selectable: false
        header:
          buttons: [ {
            cssClass: 'delete-column'
            showOnHover: true
            handler: _.bind(@removeColumn, @)
          }]
      } for column in columns

    formatResult: (type, value) ->
      if type == 'boolean'
        if value == true
          'Yes'
        else if value == false
          'No'
        else
          'N/A'
      else
        value

    remapResults: (results) ->
      resultObjects = []
      for result in results.content
        resultObject = {}
        for value, index in result
          column = results.columns[index]
          resultObject[column.name] = @formatResult(column.type, value)
        resultObjects.push(resultObject)
      resultObjects
