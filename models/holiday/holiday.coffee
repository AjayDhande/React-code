define ['backbone.relational'], (BackboneRelational) ->
  class HolidayModel extends Backbone.RelationalModel
    idAttribute: 'id'
    defaults:
      name: ''
      date: ''
