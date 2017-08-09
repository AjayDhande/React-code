define ['backbone'], (Backbone) ->
  class TeamCategoryModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']
