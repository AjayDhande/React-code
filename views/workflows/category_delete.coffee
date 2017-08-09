define ['jquery', 'backbone', 'overlay',
        'templates/workflows/category_delete'], ($, Backbone, OVLY, template) ->
  class WorkflowsCategoryDeleteView extends Backbone.View
    template: template
    events:
      'click a.yes': 'delete'
      'click a.no': 'cancel'

    cancel: (e) ->
      e.preventDefault()
      e.stopPropagation()
      OVLY.hide()

    delete: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @model.destroy(success: (response) =>
        @model.el.remove()
        OVLY.hide())

    render: ->
      @$el.html @template
      OVLY.show(@el, true, 500, 300)
      @
