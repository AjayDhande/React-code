define ['jquery', 'underscore', 'backbone',
        'models/position',
        'views/components/node',
        'views/team_position/show_modal',
        'views/team_position/edit_modal',
        'templates/team/team_positions/show_node',
        'templates/team/team_positions/edit_node',
        'templates/team/team_positions/show_list',
        'templates/team/team_positions/edit_list',
        'views/team_position/confirm_destroy'], ($, _, Backbone,
          PositionModel,
          NodeView,
          TeamPositionShowModal,
          TeamPositionEditModal,
          showNodeTemplate,
          editNodeTemplate,
          showListTemplate,
          editListTemplate,
          TeamPositionCormfirmDestroyView) ->
  class PositionView extends NodeView
    className: 'position-holder'

    initialize: (options)->
      super
      @collection = options.collection
      @templates =
        node:
          show: showNodeTemplate
          edit: editNodeTemplate
        list:
          show: showListTemplate
          edit: editListTemplate
      @model.on('change', @detectChange, @)
      @

    detectChange: ->
      if @model.hasChanged("parent_id") || @model.get("parent_id") == null
        @model.collection.resetTree()
      else
        @render()

    render: ->
      template = @templates[@treeView.view][@treeView.mode]
      if @newPosition
        @$el.addClass('new')
        window.setTimeout =>
          @$el.removeClass('new')
          @newPosition = false

      @$el.html(template(model: @model))
      @$('.children').append(@renderChildren())
      @$el.attr('id', "position-#{@model.id}")
      @createEventBinders()
      @displayAdditionalData($("#additional-data-selector").val())
      @

    createEventBinders: ->
      @$(".create-child[pid=#{@model.get('id')}]").on('click', $.proxy(@createChild,@))
      @$(".edit-modal[pid=#{@model.get('id')}]").on('click', $.proxy(@openEditModal,@))
      @$(".show-modal[pid=#{@model.get('id')}]").on('click', $.proxy(@openShowModal,@))
      @$(".expand[pid=#{@model.get('id')}]").on('click', $.proxy(@expandToggle,@))
      @$(".destroy[pid=#{@model.get('id')}]").on('click', $.proxy(@destroy,@))

    openEditModal: (e)->
      e.stopPropagation()
      e.preventDefault()
      @modal = new TeamPositionEditModal({parentView: @})

    openShowModal: (e) ->
      e.stopPropagation()
      e.preventDefault()
      @modal = new TeamPositionShowModal({parentView: @})

    createChild: (e) ->
      e.stopPropagation()
      e.preventDefault()

      @trigger('createChild', @)

    team: ->
      @treeView.model

    destroy: ->
      positions = @team().positions
      positions.fetch
        success: =>
          @view = new TeamPositionCormfirmDestroyView
            collection: positions
            model: @model
          OVLY.show @view.render().el, true, 526, 420, {classMod: "team-confirm-destroy"}


    expandToggle: (e) ->
      @$el.children('.children').slideToggle(200)
      @$el.toggleClass('collapsed')
      @treeView.checkExpandAll()
    displayAdditionalData: (data_name) ->
      @$(".additional-data").removeClass('shown')
      if data_name != ''
        @$("[data-attribute=#{data_name}]").addClass('shown')
      if data_name == ''
        @$(".position:first .additional-data-list").text('')
      else
        if data_name == 'allocation'
          if @model.get('allocation')
            @$(".position:first .additional-data-list").text("#{@model.get('allocation')}%")
        else
          if data_name == 'days_experience'
            @$(".position:first .additional-data-list").text(@model.daysExperienceString(false))
