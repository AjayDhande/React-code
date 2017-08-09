define ['jquery',
        'views/components/tool_panel',
        'templates/workflows/copy'], ($,
        ToolPanelView,
        template) ->
  class WorkflowsCopyView extends ToolPanelView
    el: '#copy-workflow'

    events:
      'click a.yes': 'create'

    initialize: ->
      super()
      options = $('#copy-workflow-options')
      options.html(template(model: @model))
      options.find('a.no').on('click', (e) => $(document).trigger('click'))

    create: ->
      title = @$el.find('input.title').val()
      if title && !@copying
        @copying = true
        @model.copy({title: title}, (response) => window.location.href = '/workflows')
