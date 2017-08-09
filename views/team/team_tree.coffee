define ['jquery', 'underscore', 'backbone',
        'views/components/tree',
        'views/team/position',
        'models/position',
        'templates/team/blank_team'], ($, _, Backbone,
          TreeView,
          PositionView,
          PositionModel,
          blankTeam) ->

  class TeamTreeView extends TreeView
    el: '#org-chart-container'
    mode: 'show'
    events:
      'click #blank-team-notice-add': 'startTeam'

    initialize: ->
      super
      @view = @options.view
      @positionSubViews = {}
      @listenTo(@collection, "modelDeleted", @destroyModelTreeFromCollection)
      @collection.bind("remove", @fetchTeam, @)

    render: ->
      $('.loading').remove()
      if (@collection.length == 0)
        $(@el).html blankTeam
        @mode = 'edit'
      super
      @supportViewModeButtons()

    setMode: (mode) ->
      @mode = mode
      @render()
    changeAdditionalData: (data_name) ->
     for key, nodeView of @nodeViews
      nodeView.displayAdditionalData(data_name)
    afterNodeCreated: (nodeView)->
      nodeView.on "createChild", @createPosition, @

    fetchTeam: ->
      @model.fetch(success: => @render())

    destroyModelTreeFromCollection: (model)->
      _.each(@collection.childrenOf(model,true), (child) =>
        @removeModel(child)
      )
      @removeModel(model)
      @createNodes()

    removeModel: (model) ->
      @collection.remove(model)
      delete @positionSubViews[model.get("id")]

    supportViewModeButtons: ->
      @$el.removeClass('org-chart-show org-chart-edit').addClass("org-chart-#{ @mode }")

    createPosition: (parentView={}) ->
      params = {"position": {}}
      if parentView.model
        params["position"]["parent_id"] = parentView.model.get("id")
      else
        params["position"]["parent_id"] = null
      @collection.create(params,
        success: (model) =>
          @createNodeView(model, true)
          @render()
        error: =>
          console.log "Failed to create position")

    startTeam: ->
      @controls.editMode()
      @createPosition()
      $('#blank-team-notice').hide()