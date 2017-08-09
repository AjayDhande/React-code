define ['backbone.relational',
        'models/workflows/task'], (BackboneRelational,
        WorkflowTaskModel) ->
  class WorkflowCategoryModel extends Backbone.RelationalModel
    url: ->
      workflow = @get('workflow')
      if @isNew()
        return "/workflows/#{workflow.get('id')}/categories"
      else
        return "/workflows/#{workflow.get('id')}/categories/#{@id}"

    idAttribute: 'id'
    relations: [{
      type: Backbone.HasMany,
      key: 'tasks',
      relatedModel: WorkflowTaskModel,
      reverseRelation: {
        key: 'category',
        includeInJson: 'id'
      }
    }]
