define ['backbone',
        'models/workflows/event',
        'views/workflows/event',
        'templates/workflows/comment'], (Backbone,
        WorkflowEventModel,
        WorkflowEventView,
        template) ->
  class WorkflowsCommentView extends Backbone.View
    el: "#workflow-events div.comment"
    events:
      "click textarea.add-comment": "expand"
      "click button.submit": "submit"

    render: ->
      @$el.html template(model: @model)
      @$el.addClass("collapse")
      $(document).mouseup(@collapse)

    expand: ->
      @$el.removeClass("collapse")

    collapse: (e) ->
      if $(e.target).parents('div.comment').length == 0
        $('#workflow-events div.comment').addClass("collapse")

    submit: (e) ->
      box = $(e.target).parent().parent()
      textarea = box.find('textarea')
      text = textarea.val()
      email = box.find('#email-all').is(':checked')
      comment = { text: text, email: email }
      if text.length > 0
        $.post("/workflows/#{@model.get('id')}/comments", { comment: comment }).done((event) =>
          model = new WorkflowEventModel(event)
          model.set('workflow', @model)
          new WorkflowEventView(model: model).prepend()
          textarea.val('')
          textarea.parent().addClass("collapse"))
