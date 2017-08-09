define ['backbone'], (Backbone) ->
  class TimeOffTypeModel extends Backbone.Model
    toString: ->
      @get('title')
