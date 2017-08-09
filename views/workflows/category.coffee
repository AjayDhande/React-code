define ['jquery',
        'backbone',
        'utils',
        'templates/workflows/category',
        'templates/workflows/add_assignee',
        'models/workflows/task',
        'views/workflows/category_delete',
        'views/workflows/task'], ($, Backbone,
        Utils,
        template,
        assignees_form,
        WorkflowTaskModel,
        WorkflowsCategoryDeleteView,
        WorkflowsTaskView) ->
  class WorkflowsCategoryView extends Backbone.View
    el: '#workflow-categories'
    append: 'category_'
    order_url: '/workflows/'+$('#workflows-edit').data('workflow_id')+'/categories/update_order'
    events:
      'mousedown .assignees' : 'onEvent'
      'click .bulk-icons .save-assignee' : 'add'
      'click .calendar-icon' : 'triggerDatePicker'

    initialize: ->
      _.bindAll(@)
      @$el.sortable
        axis:'y'
        dropOnEmpty: false
        handle: '.drag-holder'
        opacity:.6
        forceHelperSize:true
        stop:@onOrder

    render: ->
      @$el.append(template(category: @model))
      category = @$el.find('.category:last')
      category.find('.bulk-icons .assignees').append(assignees_form(assignees: []))
      @model.el = category
      deletebtn = category.find('.delete-category')
      deletebtn.on('click', @deleteFromButton)
      text = category.find('input.text')
      text.on('change', @update)
      text.on('keydown', @edit)
      category.find('a.add-task').on('click', @addFromButton)
      tasks = @model.get('tasks')
      tasks.comparator = (model) -> return model.get('id')
      tasks.each (task) => new WorkflowsTaskView(model: task, el: category.find('.workflow-tasks'), category: @).render()
      category

    addFromButton: (e) ->
      category = $(e.currentTarget).parents('.category')
      @addTask(category)

    addTask: (category) ->
      container = category.find('.workflow-tasks')
      task = new WorkflowTaskModel(id: null, text: '', completed: false, sort_order: @model.get('next_task_order'))
      view = new WorkflowsTaskView(model: task, el: container, category: @).render()
      view.find('.text').focus()
      @model.get('tasks').add(task)

    deleteFromButton: (e) ->
      new WorkflowsCategoryDeleteView(model: @model).render()

    deleteFromInput: (e) ->
      el = $(e.currentTarget)
      if el.val().length == 0
        e.preventDefault()
        category = el.parents('.category')
        if category.find('.task').size() == 0
          @model.destroy(success: (response) => category.remove())
        else
          new WorkflowsCategoryDeleteView(model: @model).render()

    enter: (e) ->
      el = $(e.currentTarget)
      category = el.parents('.category')
      tasks = category.find('.task')
      if el.val().length > 0 && tasks.length == 0
        @addTask(category)
      else
        tasks.first().find('.text').focus()

    edit: (e) ->
      if (e.keyCode == 8 || e.keyCode == 46)
        @deleteFromInput(e)
      else if e.keyCode == 13
        e.preventDefault()
        @enter(e)

    update: (e) ->
      el = $(e.currentTarget)
      text = el.val()
      category = el.parent()
      order_url = @order_url
      @model.set('workflow', @options.workflow) unless @model.get('workflow')
      if text.length > 0 && !@model.get('workflow').isNew()
        @model.save({text: text},
          success: (model, response)->
            if typeof response.id != 'undefined'
              category.attr('id', 'category_'+response.id)
              $.ajax
                url:order_url
                data:category.parent().sortable('serialize')
        )
        @model.get('workflow').set('next_category_order', @model.get('sort_order') + 1)

    onOrder: (e, ui) =>
      $.ajax
        url:@order_url
        data:ui.item.parent().sortable('serialize')

    onEvent: (e) ->
      ele = $(e.currentTarget)
      ele.off('click', '.assignee-icon')
      ele.on('click', '.assignee-icon', _.bind(@toggle, @))
      ele.parent().on 'toggle', (e, view, opening) =>
        if @open == true && view != @ && opening == true
          @open = false
          ele.removeClass('tool-active')
      $(document).click (e) =>
        @toggle(e) if @open and $(e.target).parents('.tool-panel').length == 0

    toggle: (e) ->
      e.stopPropagation()
      @open = !@open
      $(e.currentTarget).parent().trigger('toggle', [@, @open])
      $(e.currentTarget).parent().toggleClass('tool-active')
      assignee_selector = $(e.currentTarget).parent()
      if assignee_selector.find('.token-input-list-namely').length == 0
        @initializeAssigneeSelector(assignee_selector)

    initializeAssigneeSelector: (assignee_selector)->
      input = assignee_selector.find('.profile_id')
      input.tokenInput "/people",
        theme: "namely",
        preventDuplicates: true,
        onResult: Utils.convertObjectsToTokens,
        deleteText: ''

    add: (e) ->
      e.preventDefault()
      profile_id = $(e.currentTarget).prev().val()
      category_id = parseInt($(e.currentTarget).parents('.category').attr('id').split('_')[1])
      return if category_id != @model.id
      workflow_id = @model.attributes.workflow.id
      $.ajax
        url: "/workflows/"+workflow_id+"/tasks/add_assignee"
        method: 'POST'
        dataType: 'JSON'
        data:
          profile_id: profile_id
          category_id: category_id
        success: (response) ->
          if response
            $('#category_'+category_id).find('#token-input-profile_id').val('')
            $('#category_'+category_id).find('.assignees').removeClass('tool-active')

    triggerDatePicker: (e)->
      $(e.currentTarget).next('.date').datepicker
        dateFormat:'yy-mm-dd'
        onSelect: @updateTasks
      e.preventDefault()

    updateTasks: (dateText, inst) ->
      workflow_id = @model.attributes.workflow.id
      if $(inst.input[0]).parents('.task').length != 0
        task_id = parseInt($(inst.input[0]).parents('.task').attr('id').split('_')[1])
        params = {due_date: dateText, task_id: task_id}
      else
        category_id = parseInt($(inst.input[0]).parents('.category').attr('id').split('_')[1])
        params = {due_date: dateText, category_id: category_id}
      $(inst.input[0]).datepicker("destroy")
      url = "/workflows/"+workflow_id+"/tasks/set_date"
      task = new WorkflowTaskModel()
      task.setDueDate(url, params, @updateViewDate)

    updateViewDate: (response) ->
      $.each response.task_ids, (key, val)->
        $('#task_'+val).find('.calendar-icon').text(response.formatted_date)