define ['backbone', 'templates/scopes/show'], (Backbone, template) ->
  class ScopeView extends Backbone.View
    className: 'scope'
    events:
      'click .scope-delete': 'destroy'

    destroy: ->
      @model.destroy()
      @remove()

    render: ->
      @$el.html(template(scope: @model))
      @
