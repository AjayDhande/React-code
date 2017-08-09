define ['backbone',
        'collections/holiday/holiday',
        'collections/scopes/profile_scope',
        'models/holiday/holiday',
        'models/scopes/profile_scope',
        'backbone.relational'], (Backbone,
        HolidayCollection,
        ProfileScopeCollection,
        HolidayModel,
        ProfileScopeModel) ->
  class HolidayPlanModel extends Backbone.RelationalModel
    defaults:
      company_wide: true

    validate: (attributes, options) ->
      errors = {}
      errors["name"] = ["can't be blank"] unless attributes.name
      return errors if Object.keys(errors).length > 0

    relations: [{
      type: Backbone.HasMany
      key: 'holidays'
      keySource: 'holidays'
      keyDestination: 'holidays_attributes'
      relatedModel: HolidayModel
      collectionType: HolidayCollection
      includeInJSON: true
    }, {
      type: Backbone.HasMany
      key: 'profile_scopes'
      keySource: 'profile_scopes'
      keyDestination: 'profile_scopes_attributes'
      relatedModel: ProfileScopeModel
      collectionType: ProfileScopeCollection
      includeInJSON: true
    }]
