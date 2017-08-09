define ['backbone'], (Backbone) ->
  class ColumnModel extends Backbone.Model
    idAttribute: 'name'

    toString: ->
      "#{ @get('category') } / #{ @get('label') }"
