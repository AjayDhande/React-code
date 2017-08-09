define ['backbone'], (Backbone) ->
  class CategoryModel extends Backbone.Model
    abandonOrphans: true
    schema:
      title: type: 'Text', validations: ['required']
