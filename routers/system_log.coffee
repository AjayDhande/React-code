define ['backbone',
         'collections/system_log',
         'views/system_log/system_log'], (Backbone, SystemLogCollection,
         SystemLogView) ->
  class SystemLogRouter extends Backbone.SubRoute
    routes:
      '': 'systemLog'

    systemLog: ->
      if not Namely.system_logs
        Namely.system_logs = new SystemLogCollection
      new SystemLogView
        collection: Namely.system_logs

