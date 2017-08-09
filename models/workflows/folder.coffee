define ['backbone'], (Backbone) ->
  class WorkflowFolderModel extends Backbone.Model

    url: ->
      if @isNew()
        return "/folders"
      else
        return "/folders/#{@get('id')}"

    idAttribute: 'id'

    updateOrder: (url, items) ->
      $.ajax({url: url, data: items})