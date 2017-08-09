define ['jquery', 'underscore', 'backbone',
        'backbone_model_file_upload'
        'templates/workflows/add_attachment'
        'templates/workflows/attachment'], ($, _, Backbone, Fileupload, attachmentForm, attachmentTemplate) ->
  class AttachmentView extends Backbone.View

    events:
      'mousedown .attachments' : 'onEvent'
      'click .attach_file' : 'triggerFileSelection'
      'change #attachment_file' : 'save'
      'click .delete' : 'remove'

    initialize: (e) ->
      @render()

    render: ->
      @$el.find('.attachments').remove()
      @$el.append(attachmentForm(attachments: @.options.attachments, count: @.options.count))

    onEvent: (e) ->
      ele = $(e.currentTarget)
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

    triggerFileSelection: (e) ->
      $(e.currentTarget).prev('#attachment_file').click()
      e.preventDefault()

    save: (e) ->
      task_id = parseInt($(e.currentTarget).parents('.task').attr('id').split('_')[1])
      ele = $(e.currentTarget)
      fileObj = ele[0].files[0]
      @model.set "file", fileObj
      @model.save({task_id: task_id},
        success: (response)=>
          ele.val('')
          ele.prev().append(attachmentTemplate(attachment: response.attributes.attachment))
        )

    remove: (e) ->
      e.preventDefault()
      attachment_id = $(e.currentTarget).parent('.attachment').data('attachment_id')
      @model.removeAttachment(attachment_id, @removeElement($(e.currentTarget).parent('.attachment')))

    removeElement: (ele) ->
      ele.remove()