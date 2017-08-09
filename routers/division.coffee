define ['jquery', 'backbone', 'overlay',
        'collections/person'
        'views/components/tree',
        'views/people/node',
        'views/components/tree_controls',
        'views/teams/goal'], ($, Backbone, OVLY,
        PersonCollection,
        TreeView,
        PeopleNodeView,
        TreeControlsView,
        TeamGoalView)->

  class DivisionRouter extends Backbone.SubRoute
    refresh: false
    routes:
      '': 'org'
      'goals': 'goals'
      "goals/edit": "goals"

    goals: (id) ->
      new TeamGoalView

    org: (id)->
      unless @collection?
        @collection = new PersonCollection
        @collection.setFilter(divisions: {1: id})
      @collection.fetch(data: {limit: 5000}, reset: true)

      unless @orgView?
        if @collection.length > 50
          starting_view = 'list'
        else
          starting_view = 'node'
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
