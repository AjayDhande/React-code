define ['backbone', 'backbone.relational'], (Backbone) ->
  class BaseModel extends Backbone.RelationalModel
    schema:
      days: type: 'Text'
