define ['backbone'], (Backbone) ->
  class SectionModel extends Backbone.Model
    toJSON: ->
      id: @id
      title: @get('title')
      block_titles: @get('block_titles')


