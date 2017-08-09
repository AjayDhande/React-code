define ['backbone',
        'collections/subdivision'], (Backbone,
        SubdivisionCollection) ->
  class CountryModel extends Backbone.Model
    subdivisions: ->
      SubdivisionCollection.getFor(@)
    toString: ->
      @get('name')
