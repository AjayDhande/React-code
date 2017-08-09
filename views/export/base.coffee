define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ExportBaseView extends Backbone.View
    listClass: null
    template: null
    searchClass: '.search'
    events:
      'keyup .search': 'search'

    initialize: ->
      if !@collection
        throw "Not initialized collection"

      @collection.on('reset', @render, this)
      @$search = @$(@searchClass)

    render: ->
      @$(@listClass).html(@template(items: @collection))


    search: (event) ->
      search = @$search.val()
      if search
        @collection.search(search)
      else
        @collection.reset([])

