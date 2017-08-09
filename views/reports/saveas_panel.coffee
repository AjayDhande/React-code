define ['jquery', 'underscore', 'backbone',
        'views/components/tool_panel'], ($, _, Backbone,
        ToolPanelView) ->
  class SaveasPanelView extends ToolPanelView
    el: '#report-clone'
