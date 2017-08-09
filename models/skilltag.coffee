define ['backbone'], (Backbone) ->
  class SkillTagModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']

