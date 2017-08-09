define ['jquery',
        'views/components/tool_panel',
        'templates/workflows/delete'], ($,
        ToolPanelView,
        template) ->
  class WorkflowsDeleteView extends ToolPanelView
    el: '#delete-workflow'

    events:
      'click a.yes': 'delete'

    initialize: ->
      super()
      options = $('#delete-workflow-options')
      options.html(template(model: @model))
      options.find('a.no').on('click', (e) => $(document).trigger('click'))

    delete: ->
      @model.destroy(success: (response) -> window.location.href = '/workflows')
