define ['backbone', 'utils',
        'collections/person',
        'collections/skilltag',
        'views/components/tree',
        'views/components/tree_controls',
        'views/people/node',
        'views/people/filter',
        'views/people/list',
        'views/people/org'], (Backbone, Utils,
  PersonCollection, SkillTagCollection,
  TreeView, TreeControlsView, PeopleNodeView,
  PeopleFilterView, PeopleListView, PeopleOrgView) ->

  class PeopleRouter extends Backbone.SubRoute
    routes:
      '': 'people'
      'org': 'org'
      '*args': 'people'

    setupPeople: ->
      unless @collection?
        @collection = new PersonCollection
        @collection.setFilter(Utils.unserializeParams(window.location.search))

      unless @filterView
        @filterView = new PeopleFilterView(collection: @collection)
        @filterView.on 'change', (query) =>
          @collection.filterAndFetch(query)
          @navigate("/people?#{ $.param(@collection.getParams()) }")

    people: ->
      @setupPeople()

      @collection.fetch(reset: true, success: =>
        unless @listView?
          @listView = new PeopleListView
            collection: @collection

        @listView.render()
      )

    org: ->
      @setupPeople()
      fetch_options = {data: {limit: 5000}}
     # Why does this need to be desc to get asc?
      @collection.order("job_tier_order", "desc", fetch_options)
      if @collection.length > 50
        starting_view = 'list'
      else
        starting_view = 'node'

      unless @orgView?
        @orgView = new TreeView
          el: '#org-chart-container'
          collection: @collection
          view: starting_view
          nodeView: PeopleNodeView

        controls = new TreeControlsView
          view: starting_view
          el: '#org-chart-controls'

        controls.on 'changeView', (view) => @orgView.setView(view)
        controls.on 'expandAll', (view) => @orgView.expandAll(view)

      @orgView.render()
