define ['backbone'], (Backbone) ->
  class DivisionModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']

    orphans: (collection) ->
      new Backbone.Collection(collection.where({category_id: @get("category_id")}))

    toString: ->
      @get('title')
