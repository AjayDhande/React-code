define ['jquery',
        'underscore',
        'backbone',
        'utils',
        'jquery.tokeninput',
        'templates/workflows/form',
        'templates/workflows/participant',
        'views/workflows/category',
        'views/workflows/comment',
        'views/workflows/copy',
        'views/workflows/delete',
        'views/workflows/event',
        'views/workflows/kickoff',
        'models/workflows/category',
        'models/attachment'
        'collections/workflows/event',
        'tip'], ($, _, Backbone,
        Utils,
        TokenInput,
        workflowForm,
        workflowParticipant,
        WorkflowsCategoryView,
        WorkflowsCommentView,
        WorkflowsCopyView,
        WorkflowsDeleteView,
        WorkflowsEventView,
        WorkflowsKickoffView,
        WorkflowCategoryModel,
        AttachmentModel
        WorkflowEventCollection) ->
  class WorkflowsEditView extends Backbone.View
    el: '#workflows-edit'

    events:
      'change input.workflow-title': 'update'
      'change textarea.description': 'update'
      'click a.add-category': 'addCategory'
      'click .participant-reminder': 'remindParticipant'
      'click .attachment .delete-item' : 'removeAttachment'

    initialize: ->
      participants = _.sortBy(@model.get('participants'), (participant) -> participant.full_name)
      @$el.html(workflowForm(workflow: @model, participants: participants, assignees: @model.get('assignees'), attachments: @model.get('attachments')))
      categories = @model.get('categories')
      if categories.size() == 0
        @$('input.title').focus()
      else
        categories.comparator = (model) -> return model.get('id')
        categories.each (category) => new WorkflowsCategoryView(model: category, workflow: @model).render()
      events = new WorkflowEventCollection(@model.get('events').models)
      events.url = => "/workflows/#{@model.get('id')}/events"
      events.on('add', ((event) =>
        event.set('workflow', @model)
        new WorkflowsEventView(model: event).render()), @)
      _.each(events.models, (event) => new WorkflowsEventView(model: event).render())
      new WorkflowsDeleteView(model: @model)
      new WorkflowsCopyView(model: @model)
      new WorkflowsKickoffView(model: @model)
      new WorkflowsCommentView(model: @model).render()

      @listenTo(@model, "kickoff", @triggerKickoff)

      spinner = $('#spinner')
      @infiniScroll = new Backbone.InfiniScroll events,
        param: 'after'
        pageSizeParam: 'limit'
        pageSize: 10,
        success: => spinner.hide()
        onFetch: => spinner.show()
        error: => spinner.hide()
        scrollOffset: 300

      @initInputParticipants()
      @sweepInputParticipants()


    triggerKickoff: ->
      status = @$('#workflow-status')
      status.removeClass('draft')
      status.addClass('active')
      status.text('Active')
      @sweepInputParticipants()

    initInputParticipants: () ->
        @$('input#participants').tokenInput "/people",
        theme: "namely",
        preventDuplicates: true,
        onResult: Utils.convertObjectsToTokens,
        onReady: @customTokenInput,
        onAdd: @addParticipant,
        onDelete: @removeParticipant,
        tokenFormatter: (participant) => workflowParticipant(participant: participant),
        deleteText: ''

    sweepInputParticipants: () ->
      $participants = @$("#workflow-participants").find('.participant')
      status = @model.get('status')
      _.each($participants, (participant) =>
        $participant = @$(participant)
        $participant.removeClass('last')
        is_reminded = $participant.hasClass("reminded")
        $reminder = $participant.find('.participant-reminder')
        if (status == 'draft')
          $reminder.attr('disabled', 'disabled').
                   addClass('disabled').
                   data('tip', "Kickoff workflow before reminding")
        else if (status == 'active')
          if (is_reminded)
            $reminder.attr('disabled','disabled').
                     addClass('disabled').
                     data('tip', "Reminder Sent Today")
          else
            $reminder.removeAttr('disabled').
                     removeClass('disabled').
                     data('tip', "Send Reminder")
        @$("#workflow-participants").find('.participant').last().addClass('last')
        $reminder.tip()
      )

    customTokenInput: (e) ->
      input = @$('#workflow-participants').find('input')
      input.attr('placeholder', 'find people by name or title')
      input.unbind('focus')

    addParticipant: (participant_data) =>
      @model.addParticipant(participant_data, @postAddParticipant)
      $input = @$('#token-input-participants')
      $input.attr('placeholder', 'find people by name or title')

    postAddParticipant: (response) =>
      $participant = @$('#workflow-participants').find('li.participant').last()
      $participant.attr('data-participant_id', response.id)
      @sweepInputParticipants()

    removeParticipant: (participant) =>
      if window.confirm("Are you sure you want to remove the participant #{participant.full_name}?")
        @model.removeParticipant(participant)
        @sweepInputParticipants()
      else
        @$('input#participants').tokenInput("add", participant)

    remindParticipant: (e) ->
      $reminder = $(e.currentTarget)
      $participant = $reminder.parents('.participant')
      return if $reminder.attr('disabled') == 'disabled'
      id = $participant.data('participant_id')
      @model.remindParticipant(id, (response) =>
        $participant.addClass('reminded')
        @sweepInputParticipants())

    addCategory: ->
      category = new WorkflowCategoryModel(id: null, text: '', sort_order: @model.get('next_category_order'))
      @model.get('categories').add(category)
      view = new WorkflowsCategoryView(model: category, workflow: @model)
      category = view.render()
      view.addTask(category)
      category.find('input.category-item').focus()

    update: ->
      @model.save({title: $('input.title').val(), description: $('textarea.description').val()})

    removeAttachment: (e) ->
      e.preventDefault()
      attachment_id = $(e.currentTarget).parent('.attachment').data('attachment_id')
      model = new AttachmentModel()
      model.removeAttachment(attachment_id, @removeElement($(e.currentTarget).parent('.attachment')))

    removeElement: (ele) ->
      ele.remove()