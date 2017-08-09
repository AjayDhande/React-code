
define ['backbone'], (Backbone) ->
  class NodeView extends Backbone.View
    initialize: ->
      @treeView = @options.treeView
      @newPosition = @options.newPosition

    childViews: ->
      @treeView.childViewsOf(@).reverse()

    template: ->
      @templates[@treeView.view]

    render: ->
      @$el.html(@template()(model: @model))
      @$('.children').append(@renderChildren())
      @$(".expand[pid=#{@model.get('id')}]").on('click', $.proxy(@expandToggle,@))
      @

    renderChildren: ->
      _.map(@childViews(), (child) -> child.render().el)

    expandToggle: (e) ->
      @$el.children('.children').slideToggle(200)
      @$el.toggleClass('collapsed')
      @treeView.checkExpandAll()
