define ['jquery', 'backbone',
    'collections/scopes/filter',
    'models/scopes/filter'], ($, Backbone, FilterCollection, FilterModel) ->
  class ProfileScopeModel extends Backbone.RelationalModel

    relations: [
      type: Backbone.HasMany
      key: 'filters'
      relatedModel: FilterModel
      collectionType: FilterCollection
      includeInJSON: true
    ]

    destroy: (options) ->
      if @isNew()
        super(options)
      else
        @set '_destroy', 1
