define ['jquery', 'backbone',
        'collections/position',
        'templates/mobile/team'], ($, Backbone,
        PositionCollection, template) ->
  class TeamView extends Backbone.View
    el: '#members'
    template: template
    events:
      'click .members-btn-labels': 'toggleTreeView'

    initialize: ->
      @treeView = true
      @collection = new PositionCollection([], team: @model.url())
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
          positions = @collection.deepWalk()
        else
          positions = @collection.models

        @$el.html(@template(positions: positions, treeView: @treeView, teamName: @model.get('name')))
      else
        @$el.html('<div class="empty">There are no people on this team.</div>')
      @options.headerView.setTitle('', '', true)
