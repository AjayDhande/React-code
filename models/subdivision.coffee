define ['backbone'], (Backbone) ->
  class SubdivisionModel extends Backbone.Model

    toString: ->
      @get('name')
