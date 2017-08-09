define ['backbone',
        'models/team_report',
        'collections/position'], (Backbone,
        TeamReportModel, PositionCollection) ->
  class TeamModel extends Backbone.Model
    idAttribute: 'guid'
    defaults:
      name: ""
      path: ""
      team_status_id: ""
      updated_at: null
      guid: ""
      total_employees: ""
      open_positions: ""
      control_start_date: ""
      control_end_date: ""
      can_read_reports: false
      can_modify_structure: false
      order_array: []

    urlRoot: '/teams'
    paramRoot: "team"
    url: -> "/teams/" + @get("guid")
    initialize: (attributes, options) ->
      @positions = new PositionCollection([], team: @.url())

    report: ->
      @_report ?= if @get('can_read_reports') then new TeamReportModel(team: @) else null

    isNew: ->
      !@id? || @id == ''
