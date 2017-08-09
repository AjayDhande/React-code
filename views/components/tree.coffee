define ['backbone',
        'views/components/node'], (Backbone, NodeView) ->
  class TreeView extends Backbone.View
    nodeViews: {}
    view: 'node'

    initialize: ->
      @view = @options.view if @options.view?
      @collection.on 'reset', @createNodes, @
      @nodeView = @options.nodeView || NodeView

    setView: (view) ->
      @view = view
      @render()

    createNodes: ->
      @nodeViews = {}
      @$el.empty()
      @collection.each @createNodeView, @
      @render()

    createNodeView: (model, newPosition=false) ->
      @nodeViews[model.id] = new @nodeView
        model: model
        treeView: @
        treeCollection: @collection
        newPosition: newPosition

      @$el.append(@nodeViews[model.id].el)

      @afterNodeCreated(@nodeViews[model.id])

    afterNodeCreated: ->

    render: ->
      @$el.removeClass('org-chart-list org-chart-node').addClass("org-chart-#{ @view }")
      _.map(@rootNodeViews(), (view) -> view.render().el)

    rootNodeViews: ->
      @findNodeViews @collection.roots()

    findNodeViews: (models) ->
      _.map(models, (model) => @nodeViews[model.id])

    childViewsOf: (subview) ->
      @findNodeViews(subview.model.children())

    ansestorViewOf: (subview) ->
      @findNodeViews(subview.model.ancestors())

    expandAll: ->
      @$('.children').slideDown()
      @$('.collapsed').removeClass("collapsed")
      $("#expand-all").fadeOut(200)

    checkExpandAll: ->
      if @$('.collapsed').length
        $("#expand-all").fadeIn(200)
      else
        $("#expand-all").fadeOut(200)
