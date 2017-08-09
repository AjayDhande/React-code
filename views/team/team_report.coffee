define ['jquery', 'underscore', 'backbone', 'graph'], ($, _, Backbone, GRAPH) ->
  class TeamReportView extends Backbone.View
    el: '#stat-holder'
    initialize: (options) ->
      $("#vitals-button").unbind('click').bind('click', (e) ->
        $("#stat-holder").slideToggle 200
        $("#vitals-button").toggleClass 'vitals-button-closed'
      )
      @model.on('change', @render, @)

    render: ->
      @$(".people .stat").html @model.get('people_count')
      @$(".fte .stat").html @model.get('fte_count')
      @$(".openposition .stat").html @model.get('open_position_count')
      @$(".daysexperience .stat").html @model.get('days_experience')
      @$(".teamsalaries .stat").html @model.get('team_salaries')
      @$(".teamcost .stat").html @model.get('team_cost')

      # Awful hack to update graph on ajax load.
      #  TODO: Find a better way
      valuesArray = []
      colorsArray = []
      _.each @model.get('performance_graph_data'), (chartObj) ->
        valuesArray.push [chartObj["name"], chartObj["value"]]
        colorsArray.push chartObj["color"]

      if window["gdata"] and window["gdata"]["graphs"]
        _.each window["gdata"]["graphs"], (graph) ->
          if graph["name"] is "performance-levels-chart"
            graph["values"] = valuesArray
            graph["colors"] = colorsArray
        GRAPH.init()
