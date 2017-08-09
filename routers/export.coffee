define ['backbone',
        'views/export/company_page'], (Backbone,
        ExportCompanyPageView, ExportTeamPageView) ->
  class ExportRouter extends Backbone.Router
    routes:
      'company/export': 'exportCompanyPage'

    initialize: ->
      new ExportCompanyPageView
