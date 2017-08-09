define ['backbone'], (Backbone) ->
  class TimeOffBucketModel extends Backbone.Model

    plan: ->
      @collection.plans.get(@get('plan_id'))
