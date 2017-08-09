define ['backbone.relational'], (BackboneRelational) ->
  class WorkflowTaskModel extends Backbone.RelationalModel
    url: ->
      workflow = @get('category').get('workflow')
      if @isNew()
        return "/workflows/#{workflow.get('id')}/tasks"
      else
        return "/workflows/#{workflow.get('id')}/tasks/#{@id}"

    idAttribute: 'id'

    setDueDate: (url, data, callback) ->
      $.ajax({url: url, data: data, type: 'PUT', dataType: 'JSON'}).done(callback)