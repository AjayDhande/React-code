define ['jquery', 'backbone'
        'views/mobile/search',
        'templates/mobile/person_list_item',
        'templates/mobile/empty'], ($, Backbone,
        SearchView,
        itemTemplate, emptyTemplate) ->
  class PeopleView extends Backbone.View
    el: '#people-list'
    template: itemTemplate

    initialize: ->
      @cache = {}
      @collection = Namely.people
      @collection.on('reset', @refresh, @)
      @searchView = new SearchView(name: 'Person')
      @searchView.on('search', _.bind(@refresh, @))
      @searchView.render()

      @refresh()

    refresh: ->
      value = @searchView.value()
      if value
        @list = @collection.filter((p) -> p.match(value))
        @searching = true
      else
        @list = @collection.models
        @searching = false

      @render()


    focus: ->
      @options.headerView.setTitle('People', 'header-home')
      @searchView.$el.show()

    renderItem: (item) ->
      @cache[item.id] ?= @template(item.toJSON())

    renderList: ->
      _.map(@list, (item) => @renderItem(item)).join('') + '<h1 class="grey-namely-end-list"><span aria-hidden="true" class="ic grey-namely"></span></h1>'

    render: ->
      if @list.length > 0
        if @list.length == @collection.length
          @cacheFullContent ?= @renderList()
          return @$el.html(@cacheFullContent)
        @$el.html(@renderList())
      else
        if @searching
          @$el.html(emptyTemplate(message: 'There are no results for your search criteria.'))
        else
          @$el.html(emptyTemplate(message: 'Loading...'))
      