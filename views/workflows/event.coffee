define ['jquery',
        'backbone',
        'templates/workflows/event'], ($, Backbone,
        template) ->
  class WorkflowsEventView extends Backbone.View
    el: '#workflow-events ul.events'

    remove: (model) ->
      return (e) ->
        if window.confirm("Are you sure you want to delete this comment?")
          event = $(e.target).parent()
          model.destroy(success: (response) => event.remove())

    prepend: ->
      event = template(model: @model)
      @$el.prepend(event)
      @$el.find('.delete:first').on('click', @remove(@model)) if $(event).hasClass('my-comment')

    render: ->
      event = template(model: @model)
      @$el.append(event)
      @$el.find('.delete:last').on('click', @remove(@model)) if $(event).hasClass('my-comment')
