define ['backbone.relational',
        'collections/scopes/profile_scope',
        'collections/competencies/competency',
        'models/scopes/profile_scope',
        'models/competency'], (BackboneRelational,
        ProfileScopeCollection,
        CompetencyCollection,
        ProfileScopeModel,
        CompetencyModel) ->
  class CompetencySetModel extends Backbone.RelationalModel
    url: ->
      category = @get('category')
      if @isNew()
        return "/competency_categories/#{category.get('id')}/sets"
      else
        return "/competency_categories/#{category.get('id')}/sets/#{@id}"
    idAttribute: 'id'
    defaults:
      company_wide: true

    validate: (attributes, options) ->
      errors = {}
      errors["category"] = ["can't be blank"] unless @get('category') && @get('category').get('id')
      return errors if Object.keys(errors).length > 0

    relations: [{
      type: Backbone.HasMany,
      key: 'competencies',
      relatedModel: CompetencyModel,
      collectionType: CompetencyCollection,
      reverseRelation: {
        key: 'competency-set',
        includeInJson: 'id'
      }
    }, {
      type: Backbone.HasMany,
      key: 'profile_scopes',
      keySource: 'profile_scopes',
      keyDestination: 'profile_scopes_attributes',
      relatedModel: ProfileScopeModel,
      collectionType: ProfileScopeCollection,
      includeInJSON: true
    }]
