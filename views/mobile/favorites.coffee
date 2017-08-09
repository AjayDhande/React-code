define ['jquery', 'backbone',
        'templates/mobile/person_list_item',
        'templates/mobile/empty'], ($, Backbone, itemTemplate, emptyTemplate) ->
  class FavoritesView extends Backbone.View
    el: '#favs-list'
    template: itemTemplate

    initialize: ->
      @collection = Namely.favorites
      @collection.on('reset', @render, @)
      @collection.on('add', @render, @)
      @collection.on('remove', @render, @)

    render: ->
      if @collection.length > 0
        @$el.html(@collection.map((person) =>
          @template(person.toJSON())).join('')
        )
      else
        @$el.html(emptyTemplate(message: 'No favorites have been added yet.'))
