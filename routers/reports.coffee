define ['backbone',
        'collections/reports/report',
        'views/reports/index',
        'views/reports/show',
        'views/reports/new'], (Backbone,
        ReportCollection,
        ReportsIndexView,
        ReportShowView,
        ReportsNewView) ->

  class ReportRouter extends Backbone.SubRoute
    routes:
      'new' : 'new'
      ':id': 'show'
      '': 'index'

    index: ->
      new ReportsIndexView()

    new: ->
      new ReportsNewView()

    show: (id) ->
      collection = new ReportCollection()
      model = new collection.model(id: id)
      model.fetch()
      new ReportShowView(model: model)
