define ['jquery',
        'underscore',
        'backbone',
        'views/workflows/folder',
        'models/workflows/folder',
        'models/workflow',
        'models/workflows/task',
        'models/workflows/category'
        'jquery.tablesorter'], ($, _, Backbone, WorkflowFolderView, WorkflowFolderModel, WorkflowModel, WorkflowTaskModel, WorkflowCategoryModel) ->
  class WorkflowsIndexView extends Backbone.View
    el: '#workflows-index'
    folder_order_url: '/folders/update_order'
    workflow_order_url: '/workflows/update_order'
    events:
      'click .create-folder': 'form'
      'click .toggle-workflow-folder' : 'handleToggle'
      'click input.check' : 'complete'
      'mousedown .assignees, .attachments' : 'onEvent'

    initialize: ->
      @$el.find('.workflows-table').tablesorter({
        textExtraction: textExtraction,
        sortList: [[2,1]]
      })
      $('.workflow-folders').sortable
        axis:'y'
        dropOnEmpty: false
        handle: '.folder-drag-holder'
        opacity:.6
        forceHelperSize:true
        placeholder: 'highlight'
        stop:@onOrder
      $('.workflows .workflow').draggable
        revert: 'invalid'
        handle: '.workflow-drag-holder'
        connectToSortable: '.workflows.inside'
      $('.workflow-folders .workflow-folder').droppable
        accept: '.workflow'
        hoverClass: 'folder-highlight'
        over: @handleTargetVisual
        drop: @handleDropEvent
      $('.workflows.inside').sortable
        axis:'y'
        dropOnEmpty: false
        handle: '.workflow-drag-holder'
        opacity:.6
        forceHelperSize:true
        stop:@onOrderWorkflow

    form: (e)=>
      e.preventDefault()
      last_element = $('#workflow-holder .workflow-folders')
      workflow_folder = new WorkflowFolderModel()
      new WorkflowFolderView(el: last_element, model: workflow_folder)

    handleToggle: (e) ->
      target = $(e.target)
      toggle = target.parent()
      sets = toggle.parent().find('.content')
      sets.toggle()
      if sets.is(':hidden')
        target.attr('readonly', 'readonly')
        toggle.removeClass('close')
        toggle.addClass('close')
      else
        target.removeAttr('readonly')
        toggle.removeClass('close')

    onOrder: (e, ui) =>
      workflow_folder = new WorkflowFolderModel()
      items = ui.item.parent().sortable('serialize')
      workflow_folder.updateOrder(@folder_order_url, items)

    handleDropEvent: (e, ui) =>
      folder_id = $(e.target).data('folder_id')
      return if folder_id == $(ui.draggable).parent().parent().parent().data('folder_id')
      workflow_id = $(ui.draggable).data('workflow_id')
      params = {'id': workflow_id, 'workflow': {'id': workflow_id, 'workflow_folder_id': folder_id}}
      data = JSON.stringify(params)
      model = new WorkflowModel(id: workflow_id)
      model.updateFolder(data, @modifyWorkflowPosition)

    modifyWorkflowPosition: (response) ->
      draggable = $('#workflow_'+response.id)
      draggable.removeAttr('style').removeClass('outside').addClass('inside')
      droppable = $('#workflow_folder_'+response.workflow_folder_id)
      droppable.find('.workflows.inside').append(draggable)

    handleTargetVisual: (e, ui) ->
      unless $(e.target).find('.toggle-container').hasClass('close')
        $(e.target).removeClass('folder-highlight')
        if $(e.target).find('.workflow-position')
          $(e.target).find('.workflow-position').remove()
        $(e.target).find('.workflows').append('<div class="workflow-position"></div>')

    onOrderWorkflow: (e, ui) =>
      ui.item.attr('id', 'workflow_'+ui.item.data('workflow_id'))
      folder_param = "&folder_id="+ui.item.parent().parent().parent().data('folder_id')
      data = ui.item.parent().sortable('serialize') + folder_param
      model = new WorkflowModel()
      model.updateOrder(@workflow_order_url, data)

    complete: (e)->
      completed = $(e.currentTarget).is(':checked')
      el = @$(e.currentTarget).parents('.task').find('.text')
      if completed
        el.addClass('complete')
      else
        el.removeClass('complete')
      task_id = @$(e.currentTarget).parents('.task').data('task_id')
      category_id = @$(e.currentTarget).parents('.category').data('category_id')
      workflow_id = @$(e.currentTarget).parents('.category').prevAll('.workflow:first').data('workflow_id')
      workflow = WorkflowModel.findOrCreate(id: workflow_id)
      category = WorkflowCategoryModel.findOrCreate(id: category_id, workflow: workflow)
      task = WorkflowTaskModel.findOrCreate(id: task_id, category: category)
      task.save({completed: completed}) if el.text().length > 0

    onEvent: (e) ->
      ele = $(e.currentTarget)
      if ele.hasClass('assignees')
        ele.off('click', '.assignee-icon')
        ele.on('click', '.assignee-icon', _.bind(@toggle, @))
      else
        ele.off('click', '.attachment-icon')
        ele.on('click', '.attachment-icon', _.bind(@toggle, @))
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