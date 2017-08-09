define ['jquery',
        'backbone',
        'utils',
        'templates/workflows/task',
        'templates/workflows/add_assignee',
        'templates/workflows/assignee',
        'models/attachment',
        'views/workflows/attachment'], ($, Backbone,
        Utils,
        template,
        assignee_form,
        taskAssignee,
        AttachmentModel,
        AttachmentView) ->
  class WorkflowsTaskView extends Backbone.View
    order_url: '/workflows/'+$('#workflows-edit').data('workflow_id')+'/tasks/update_order'
    events:
      'click .task-item' : 'setFocus'
      'click .task-info .save-assignee' : 'add'
      'click .delete-assignee' : 'remove'

    initialize: ->
      _.bindAll(@)
      @$el.sortable
        axis:'y'
        opacity:.6
        forceHelperSize:true
        stop:@onOrder

    render: ->
      @$el.append(template(task: @model))
      task = @$el.find('.task:last')
      assignees = if typeof @model.get('assignees') != "undefined" then @model.get('assignees') else []
      attachments = if typeof @model.get('attachments') != "undefined" then @model.get('attachments') else []
      task.find('.assignees').append(assignee_form(assignees: assignees))
      attachment = new AttachmentModel()
      new AttachmentView(el: task.find('.task-info'), model: attachment, attachments: attachments, count: @model.get('attachments_count'))
      task.find('.task-info').addClass('complete') if @model.get('completed')
      text = task.find('.text')
      text.on('blur', @update)
      text.on('keydown', @edit)
      task.find('input.check').on('change', @complete)
      task.find('a.remove-task').click(@removeTask)
      task

    moveCursorToEnd: (input) ->
      range = document.createRange()
      selection = window.getSelection()
      range.setStart(input.get(0), 1)
      range.collapse(true)
      selection.removeAllRanges()
      selection.addRange(range)
      input.focus()

    delete: (target) ->
      @model.destroy(success: (response) =>
        input = target.parent().parent().prev().find('.text')
        target.parent().parent().remove()
        if input.length == 0
          category = @$el.parent()
          category.find('.text').focus()
        else
          @moveCursorToEnd(input))

    enter: (target) ->
      siblings = target.parents('.task').next()
      if target.text().length > 0 && siblings.length == 0
        category = target.parents(".category")
        @options.category.addTask(category)
      else
        siblings.find('.text').focus()

    edit: (e) ->
      target = $(e.currentTarget)
      if (e.keyCode == 8 || e.keyCode == 46)
        if target.text().length == 0
          e.preventDefault()
          @delete(target)
      else if e.keyCode == 13
        e.preventDefault()
        @enter(target)

    update: (e) ->
      text = $(e.currentTarget).text()
      task = $(e.currentTarget).parent().parent()
      order_url = @order_url
      @model.set('category', @options.category.model) unless @model.get('category')
      @model.get('category').set('next_task_order', @model.get('sort_order') + 1)
      if task.attr('id').search("null") == -1
        @model.unset('sort_order')
      if text.length > 0 && @model.get('category') && !@model.get('category').isNew()
        @model.save({text: text},
          success: (model, response)->
            if typeof response.id != 'undefined'
              task.attr('id', 'task_'+response.id)
              $.ajax
                url:order_url
                data:task.parent().sortable('serialize')
        )

    complete: (e) ->
      completed = $(e.currentTarget).is(':checked')
      el = @$(e.currentTarget).parents('.task').find('.text')
      if completed
        el.addClass('complete')
      else
        el.removeClass('complete')
      @model.save({completed: completed}) if el.text().length > 0 && @model.get('category').get('id')

    removeTask: (e) ->
      el = $(e.currentTarget)
      @model.destroy(success: => el.parents('.task').remove())

    onOrder: (e, ui) =>
      $.ajax
        url:@order_url
        data:ui.item.parent().sortable('serialize')

    setFocus: (e)->
      div = e.currentTarget
      div.focus()
      if typeof window.getSelection isnt "undefined" and typeof document.createRange isnt "undefined"
        range = document.createRange()
        range.selectNodeContents div
        range.collapse false
        sel = window.getSelection()
        sel.removeAllRanges()
        sel.addRange range
      else unless typeof document.body.createTextRange is "undefined"
        textRange = document.body.createTextRange()
        textRange.moveToElementText div
        textRange.collapse false
        textRange.select()

    add: (e) ->
      e.preventDefault()
      profile_id = $(e.currentTarget).prev().val()
      task_id = parseInt($(e.currentTarget).parents('.task').attr('id').split('_')[1])
      return if task_id != @model.id
      workflow_id = @model.attributes.category.attributes.workflow.id
      $.ajax
        url: "/workflows/"+workflow_id+"/tasks/add_assignee"
        method: 'POST'
        dataType: 'JSON'
        data:
          profile_id: profile_id
          task_id: task_id
        success: (response) ->
          $('#task_'+task_id).find('.assignee-list .label').remove()
          $('#task_'+task_id).find('.assignee-list').append(taskAssignee(assignee: response.assignee))

    remove: (e) ->
      e.preventDefault()
      element = $(e.currentTarget)
      profile_id = element.parents('.info').data('profile_id')
      task_id = parseInt(element.parents('.task').attr('id').split('_')[1])
      return if task_id != @model.id
      workflow_id = @model.attributes.category.attributes.workflow.id
      $.ajax
        url: "/workflows/"+workflow_id+"/tasks/"+task_id+"/destroy_assignee"
        method: 'DELETE'
        dataType: 'JSON'
        data:
          profile_id: profile_id
        success: (response) ->
          if response['success']
            element.parents('.info').remove()
