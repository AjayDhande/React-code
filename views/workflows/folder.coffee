define ['jquery', 'underscore', 'backbone'
        'templates/workflows/add_folder',
        'templates/workflows/folder'], ($, _, Backbone, folder_form, folder_structure) ->
  class WorkflowFolderView extends Backbone.View

    initialize: (e) ->
      @render()

    events:
      'click .save-folder': 'save'

    render: ->
      @$el.append(folder_form())

    save: (e)->
      e.preventDefault()
      title = $(".folder-title").val()
      @model.save({title: title},
        success: (resp)=>
          if resp
            @updateFolderStructure(resp.changed.folder)
        )

    updateFolderStructure: (folder_data)->
      @$el.append(folder_structure(folder: folder_data))
      $('.folder-form').remove()
      $('#workflow_folder_'+folder_data.id).find('.content').css('display', 'block')