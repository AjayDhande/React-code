define ['backbone'], (Backbone) ->
  class TreeControlsView extends Backbone.View
    @view = 'node'
    events:
      'click #list-view': 'changeView'
      'click #node-view': 'changeView'
      'click #expand-all': 'expandAll'

    initialize: ->
      @view = @options.view if @options.view?

      @render()

    render: ->
      if @view == "list"
        @$("#list-view").addClass("view-selected")
        @$("#node-view").removeClass("view-selected")
      else
        @$("#node-view").addClass("view-selected")
        @$("#list-view").removeClass("view-selected")

    changeView: (e) ->
      $target = $(e.currentTarget)
      if !$target.attr('disabled')
        @view = $target.attr('data-view')
        @trigger 'changeView', @view
        @render()

    expandAll: ->
      @trigger 'expandAll', @view