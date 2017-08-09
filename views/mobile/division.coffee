define ['jquery', 'backbone',
        'collections/person'
        'templates/mobile/division'], ($, Backbone,
        PersonCollection, template) ->
  class DivisionView extends Backbone.View
    el: '#members'
    template: template
    events:
      'click .members-btn-labels': 'toggleTreeView'

    initialize: ->
      @treeView = true
      @collection = new PersonCollection
      @collection.setFilter(divisions: {1: @model.get('guid')})
      @$el.empty()
      @$el.html('<div class="loading"></div>')
      @model.on('change', @render, @)
      @collection.on('reset', @render, @)
      @collection.fetch(reset: true)

    toggleTreeView: (e)->
      e.preventDefault()
      @treeView = !@treeView
      @render()

    render: ->
      if @collection.length > 0
        if @treeView
          people = @collection.deepWalk()
        else
          people = @collection.models

        @$el.html(@template(people: people, treeView: @treeView, teamName: @model.get('title')))
        @options.headerView.setTitle('', '', true)
      else
        @$el.html('<div class="empty">There are no people on this team.</div>')
      @options.headerView.setTitle('', '', true)
