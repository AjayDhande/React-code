define ['backbone',
        'views/company/report_graph',
        'views/company/goals/index',
        'views/company/goals/settings',
        'graph'], (Backbone,
        CompanyReportGraphView,
        CompanyGoalsView,
        CompanyGoalsSettingsView) ->

  class CompanyRouter extends Backbone.SubRoute
    routes:
      'goals/settings': 'goalsSettings'
      'goals': 'goals'
      'reports/:report': 'report'

    report: (report) ->
      new CompanyReportGraphView
        reportType: report

    goals: ->
      new CompanyGoalsView()

    goalsSettings: ->
      new CompanyGoalsSettingsView()
