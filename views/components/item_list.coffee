define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ItemListView extends Backbone.View
    initialize: (options) ->
      @options = options
      @template = @options.template if @options.template?
      @collection.on('reset', @render, @)
      @collection.on('add', @addItem, @)
      @render()

    render: ->
      if @collection.length > 0
        @$el.html(_.map(@collection.models, (item)=>
          @template({item: item.toJSON()})
        ).join(''))
      else
        unless @collection.fetching
          @$el.html('<li>There are no results for your search criteria.</li>')

    addItem: (item)->
      @$el.append(@template({item: item.toJSON()}))
