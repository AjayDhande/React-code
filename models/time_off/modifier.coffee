define ['backbone', 'collections/office', 'collections/division'
  'collections/scopes/profile_scope', 'models/scopes/profile_scope',
  'backbone-forms', 'forms/reference_editor', 'backbone.relational'], (Backbone,
  OfficeCollection, DivisionCollection, ProfileScopeCollection,
  ProfileScopeModel) ->
  class ModifierModel extends Backbone.RelationalModel
    abandonOrphans: true
    defaults:
      days_off: 0

    relations: [
      type: Backbone.HasMany
      key: 'profile_scopes'
      relatedModel: ProfileScopeModel
      collectionType: ProfileScopeCollection
      includeInJSON: true
    ]
