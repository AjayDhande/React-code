define ['jquery', 'underscore', 'backbone', 'utils',
        'goog!visualization,1,packages:[corechart]', 'jquery.tablesorter'], ($, _, Backbone, Utils) ->
  class TeamReportGraphView extends Backbone.View
    events:
      'change .report-graph-date': 'changeRange'
    reportType: null
    tries: 3
    el: '#report-graph'
    performanceEl: '#performance-pie'
    timeRanges:
      ytd:
        startDate: new Date((new Date).getFullYear(), 0, 1)
        endDate: new Date()
        title: 'Year to Date'
      l6m:
        startDate: new Date((new Date).getTime() - 182 * 24 * 60 * 60 * 1000)
        endDate: new Date()
        title: 'Last 6 Months'
      l12m:
        startDate: new Date((new Date).getTime() - 365 * 24 * 60 * 60 * 1000)
        endDate: new Date()
        title: 'Last 12 Months'
      all:
        startDate: new Date((new Date).getTime() - 5 * 365 * 24 * 60 * 60 * 1000)
        endDate: new Date()
        title: 'All Time'

    initialize: (options) ->
      Utils.setupDatePicker()

      if @$el? and @$el.length
        @initializeRange()
        @fetch()

    initializeRange: ->
      @timeRange = @timeRanges.ytd
      $rangeSelect = @$('.report-graph-date')
      for own key, range of @timeRanges
        option = $('<option>', {value: key, text: range.title})
        if range == @timeRange
          option.attr('selected', 'selected')
        $rangeSelect.append(option)

    fetch: ->
      $.ajax
        url: "/teams/#{ @options.id }/get_statistics/#{ @options.reportType }"
        dataType: 'json'
        type: 'GET'
        data:
          step: 10
          start_date: "#{@timeRange.startDate.getFullYear()}-#{@timeRange.startDate.getMonth() + 1}-#{@timeRange.startDate.getDate()}"
          end_date: "#{@timeRange.endDate.getFullYear()}-#{@timeRange.endDate.getMonth() + 1}-#{@timeRange.endDate.getDate()}"

        success: (data) =>
          @render(data)
        error: (data) =>
          @tries--
          if @tries > 0
            @fetch()
          else
            alert('Connection error.')

    render: (data) ->
      dataTable = []
      dataTable = new google.visualization.DataTable()
      dataTable.addColumn('date', 'Date')
      headerCount = 1
      refLookup = {}
      colors = []
      for ref in _.values(data.refs).reverse()
        dataTable.addColumn('number', ref.title)
        refLookup[ref.id] = headerCount
        colors.push(ref.color)
        headerCount++

      if colors.length == 0
        colors = ["#2C7BC6"]


      for row in data.results
        dataRow = [new Date(row.day)]
        i = headerCount
        while i -= 1
          dataRow.push(0)
        for item in row.data
          dataRow[refLookup[item[1]]] = item[0]
        dataTable.addRow(dataRow)


      chart = new google.visualization.AreaChart(@$('.report-graph-canvas')[0])
      chart.draw dataTable,
        areaOpacity: .1
        color:["#2C7BC6"]
        colors: colors
        hAxis:
          gridlines:
            color:"#FFFFFF"
          showTextEvery: 1
          slantedText: false
          textStyle:
            color: "#6B6B6B"
            fontSize: 9
        vAxis:
          format: "#,###"
          gridlines:
            color:"#FFFFFF"
          textStyle:
            color: "#6B6B6B", fontSize: 11
        animation: { duration: 1500, easing: 'out' }
        chartArea: { left:0, top:10, width: "100%" }
        legend: 'bottom'
        isStacked: true
        width: 700,
        height: 200


    changeRange: (e) ->
      @timeRange = @timeRanges[e.currentTarget.value]
      @trigger('change:range', @timeRange)
      @fetch()
