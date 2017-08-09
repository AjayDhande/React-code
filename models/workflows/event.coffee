define ['backbone.relational'], (BackboneRelational) ->
  class WorkflowEventModel extends Backbone.RelationalModel
    idAttribute: 'id'
    url: -> "/workflows/#{@get('workflow').get('id')}/events/#{@id}"
