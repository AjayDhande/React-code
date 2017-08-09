define ['jquery', 'underscore', 'backbone',
        'templates/performance/templates/choice'], ($, _, Backbone, template) ->
  class ReviewTemplateQuestionChoiceView extends Backbone.View
    template: template
    
    events: 
      'click .delete': 'closeChoice'
    
    initialize: (options) ->
      @container = options.container
      @choice = options.choice
      @question_id = options.question_id
      @render()
    
    render: ->
      @$el = $(@template({
          choice: @choice,
          question_id: @question_id
        })).appendTo(@container)
    
    closeChoice: ->
      if @container.children().length > 1
        @$el.remove()
