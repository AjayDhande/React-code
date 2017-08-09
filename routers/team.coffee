define ['jquery', 'backbone', 'overlay',
        'models/team',
        'collections/team',
        'collections/team_category',
        'views/teams/category',
        'views/teams/edit',
        'views/teams/export',
        'views/teams/goal',
        'views/teams/index',
        'views/team/team_report',
        'views/team/report_graph',
        'views/team/settings',
        'views/team/team_sharing',
        'views/team/team_tree',
        'views/team/position',
        'views/team/team_controls'], ($, Backbone, OVLY,
        TeamModel,
        TeamCollection,
        TeamCategoryCollection,
        TeamCategoryView,
        TeamEditView,
        TeamExportView,
        TeamGoalView,
        TeamIndexView,
        TeamReportView,
        TeamReportGraphView,
        TeamSettingsView,
        TeamSharingView,
        TeamTreeView,
        PositionView,
        TeamControlsView)->

  class TeamRouter extends Backbone.SubRoute
    refresh: false
    routes:
      "add": "newTeam"
      ":id": "orgChart"
      ":id/org-chart": "orgChart"
      ":id/goals": "goals"
      ":id/goals/edit": "goals"
      ":id/reports/export": "export"
      ":id/reports/:report": "report"
      ":id/settings": "settings"
      ":id/settings/sharing": "sharing"
      "index": "index"
      "": "index"

    newTeam: ->
      @list = $("#team-list")
      if not @teams
        @teams = new TeamCollection()
        @teams.fetch()
      team = new TeamModel()
      @view = new TeamEditView
        collection: @teams
        model: team

      OVLY.show(@view.render().el, true, 500, 592)
      OVLY.setCloseRedirect('teams')
      view = new TeamCategoryView()
      $(window).on 'ovly:close', (e) =>
        e.preventDefault()
        this.navigate("teams", {trigger: true})

    orgChart: (id)->
      team = new TeamModel(guid: id, id: id)
      team.fetch success: =>
        teamView = new TeamTreeView
          collection: team.positions
          model: team
          view: 'list'
          nodeView: PositionView

        controlsView = new TeamControlsView(view: 'list')
        controlsView.on 'changeMode', (mode) -> teamView.setMode(mode)
        controlsView.on 'changeAdditionalData', (data_name) -> teamView.changeAdditionalData(data_name)
        controlsView.on 'changeView', (view) -> teamView.setView(view)
        controlsView.on 'createRoot', (view) -> teamView.createPosition()
        controlsView.on 'expandAll', (view) -> teamView.expandAll()

        teamView.controls = controlsView

        team.positions.fetch(reset: true)

        if report = team.report()
          team.positions.on 'sync', -> report.fetch(reset: true)
          new TeamReportView(model: report)

    goals: (id) ->
      new TeamGoalView()

    index: ->
      @list = $("#team-list")
      $('.button.add.team').click (e) =>
        e.preventDefault()
        this.navigate("teams/add", {trigger: true})
      if not @teams
        @teams = new TeamCollection()
        @teams.fetch(reset: true)
      if @view?
        @view.remove()
        OVLY.hide()

      if Namely.TeamIndexView
        @view = Namely.TeamIndexView
      else
        @view = new TeamIndexView
          collection: @teams
        Namely.TeamIndexView = @view

    export: ->
      new TeamExportView

    report: (guid, report) ->
      new TeamReportGraphView
        reportType: report
        id: guid

    settings: (id) ->
      team = new TeamModel(guid: id, id: id)
      team.fetch success: =>
        new TeamSettingsView(model: team)
        Namely.teamCategories ?= new TeamCategoryCollection
        if !Namely.teamCategories.length
          Namely.teamCategories.fetch async: false
        new TeamCategoryView(model: team)

    sharing: (guid) ->
      Namely.teamCollaborators.team = new TeamModel(id: guid)
      new TeamSharingView
        collection: Namely.teamCollaborators
        autoRender: true
        el: '#sharing-list'
