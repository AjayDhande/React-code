define ['jquery',
        'views/components/tool_panel',
        'templates/holiday/plan_delete'], ($,
        ToolPanelView,
        template) ->
  class HolidayPlanDeleteView extends ToolPanelView
    template: template
    events:
      'click a.yes': 'delete'

    initialize: ->
      super()
      options = @$('.delete-plan-options')
      options.html(template(model: @model))
      options.find('a.no').on('click', (e) => $(document).trigger('click'))

    toggle: (e) ->
      super(e)

    delete: (e) ->
      e.preventDefault()
      e.stopPropagation()
      if @model.isNew()
        @model.collection.remove(@model)
        @model.el.remove()
      else
        @model.destroy(wait: true).then (response) =>
          @model.el.remove()
