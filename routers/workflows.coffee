define ['backbone',
        'views/workflows/edit',
        'views/workflows/index',
        'models/workflow'], (Backbone,
        WorkflowsEditView,
        WorkflowsIndexView,
        WorkflowModel) ->
  class WorkflowsRouter extends Backbone.SubRoute
    routes:
      'tasks': 'index'
      ':id/edit': 'edit'
      ':id': 'edit'
      '' : 'index'

    edit: (id) ->
      model = new WorkflowModel(id: id)
      model.fetch(success: => new WorkflowsEditView(model: model))

    index: ->
      new WorkflowsIndexView()