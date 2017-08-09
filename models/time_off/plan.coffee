define ['backbone',
    'models/time_off/type',
    'models/time_off/base',
    'models/time_off/modifier',
    'collections/time_off/modifier', 'backbone.relational'], (Backbone,
    TypeModel, BaseModel, ModifierModel, ModifierCollection) ->

  class PlanModel extends Backbone.RelationalModel
    defaults:
      days_off: 0.0
      refresh_on_anniversary: false
      refresh_month: 1
      refresh_day: 1
      prorate_first_accrual: false
      carries_over: false
      carryover_expiration_month: 3
      carryover_expiration_day: 1
      accrual_period: 'annual'
      default: false

    toJSON: ->
      json = super()
      json.modifiers = [] unless json.modifiers?
      json

    toString: ->
      @get('title')

    relations: [
        type: Backbone.HasMany
        key: 'modifiers'
        relatedModel: ModifierModel
        collectionType: ModifierCollection
        includeInJSON: true
      ,
        type: Backbone.HasOne
        key: 'base'
        relatedModel: BaseModel
    ]

    type: ->
      @types.get(@get('type_id'))

    types: ->
      @collection.types

    addModifier: ->
      modifier = new (@get('modifiers').model)
      @get('modifiers').add([modifier])
