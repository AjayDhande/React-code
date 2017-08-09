define ['backbone.relational', 'models/competencies/set'], (BackboneRelational, SetModel) ->
  class CompetencyCategoryModel extends Backbone.RelationalModel
    url: ->
      if @isNew()
        return "/competency_categories/"
      else
        return "/competency_categories/#{@get('id')}"

    idAttribute: 'id'
    relations: [{
      type: Backbone.HasMany,
      key: 'sets',
      relatedModel: SetModel,
      reverseRelation: {
        key: 'category',
        includeInJson: 'id'
      }
    }]
