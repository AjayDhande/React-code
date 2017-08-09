define ['backbone.relational'], (BackboneRelational) ->
  class JobTitleModel extends Backbone.RelationalModel

    toString: ->
      @get('full_title')
