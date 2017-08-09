define ['jquery',
        'views/components/tool_panel',
        'templates/workflows/kickoff'], ($,
        ToolPanelView,
        template) ->
  class WorkflowsKickoffView extends ToolPanelView
    el: '#kickoff-workflow'

    events:
      'click a.kickoff-now': 'kickoff'

    initialize: ->
      super()
      options = @$('#kickoff-workflow-options')
      options.html(template())
      options.find('a.kickoff-later').on('click', (e) => $(document).trigger('click'))

    kickoff: (e) ->
      sendmail = @$('#kickoff-email').is(':checked')
      @model.kickoff({'status': 'active'}, sendmail,
        (response) =>
          @model.trigger("kickoff")
          @el.remove())
