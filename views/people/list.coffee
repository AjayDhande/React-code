define ['backbone', 'views/people/list_head',
  'views/components/item_list',
  'templates/people/list_item'], (
    Backbone,
    ListHeadView,
    ItemListView,
    listItemTemplate) ->
  class PeopleListView extends Backbone.View
    el: '#people-list'
    initialize: ->
      head = new ListHeadView
        el: 'ul.fake_table_head'
        collection: @collection
      head.on('change', => @trigger('filter'))

      list = new ItemListView
        collection: @collection
        template: listItemTemplate
        el: '#people-list'
      @collection.on('reset', => @setupInfiniScroll())
      @setupInfiniScroll()

    setupInfiniScroll: ->
      scroll = new Backbone.InfiniScroll @collection,
        param: 'after'
        pageSizeParam: 'limit'
        pageSize: 30
        includePage: true
        success: (collection, response) =>
          $('#people-loading').hide()
          if response.people and response.people.length > 0
            scroll.fetchSuccess(collection, response.people)
        error: => $('#people-loading').hide()
        onFetch: => $('#people-loading').show()
        scrollOffset: 300
