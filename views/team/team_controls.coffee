define ['backbone'], (Backbone) ->
  class TeamControls extends Backbone.View
    el: '#org-chart-controls'

    events:
      'click #show-mode': 'changeMode'
      'click #edit-mode': 'changeMode'
      'click #list-view': 'changeView'
      'click #node-view': 'changeView'
      'click #expand-all': 'expandAll'
      'click #create-root': 'createRoot'
      'change #additional-data-selector': "changeAdditionalData"

    initialize: ->
      @view = @view || @options.view
      @render()

    render: ->
      if @mode == "edit"
        @$("#edit-mode").attr("data-mode", "show")
        @$("#edit-mode").html("Done")
        @$("#create-root").show()
      else
        @$("#edit-mode").attr("data-mode", "edit")
        @$("#edit-mode").html("Edit")
        @$("#create-root").hide()
      if @view == "list"
        @$("#list-view").addClass("view-selected")
        @$("#node-view").removeClass("view-selected")
      else
        @$("#node-view").addClass("view-selected")
        @$("#list-view").removeClass("view-selected")
      @$("#expand-all").hide()

    changeView: (e) ->
      $target = $(e.currentTarget)
      if !$target.attr('disabled')
        @view = $target.attr('data-view')
        @trigger 'changeView', @view
        @render()

    changeMode: (e) ->
      $target = $(e.currentTarget)
      if !$target.attr('disabled')
        @mode = $target.attr('data-mode')
        @trigger 'changeMode', @mode
        @render()

    editMode: ->
      @mode = 'edit'
      @trigger 'changeMode', @mode
      @render()

    expandAll: ->
      @trigger 'expandAll'

    createRoot: ->
      @trigger 'createRoot'
    changeAdditionalData: ->
      @trigger 'changeAdditionalData', @$('#additional-data-selector').val()
