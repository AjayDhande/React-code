define ['backbone'], (Backbone) ->
  class SystemLogModel extends Backbone.Model
    parse: (resp, xhr) ->
      resp['created_at'] = new Date(resp['created_at'])
      resp
