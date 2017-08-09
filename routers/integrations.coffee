define ['backbone',
  'views/integrations/zenpayroll/employee_sync_view'], (Backbone,
  EmployeeSyncView)->

  class IntegrationsRouter extends Backbone.SubRoute
    # refresh: false
    routes:
      "zenpayroll_employees" : "sync_employees"

    sync_employees: ->
      @view = new EmployeeSyncView
      @view.render()

