define ['jquery', 'underscore', 'backbone', 'utils','overlay'
		    'templates/team/org_chart_modals/edit_modal'
        'collections/job_title',
        'models/position',
        'views/team_position/confirm_destroy',
        'views/team_position/allocation_editor',
        'jquery.tokeninput'], ($, _, Backbone, Utils, OVLY,
          edit_modal_template,
          JobTitleCollection,
          PositionModel,
          TeamPositionCormfirmDestroyView,
          TeamPositionAllocationEditorView
          ) ->
  class TeamPositionEditModal extends Backbone.View
    events:
      'click #save' : 'save'
      'click #destroy': 'destroy'


    initialize: (options)->
      @parentView = options.parentView
      @jobTitles = new JobTitleCollection
      @jobTitles.fetch(async: false)
      @model = options.parentView.model
      @model.fetch(success: =>
        @render()
      )
      Utils.setupDatePicker(@$el)

    render: ->
      @$el.html edit_modal_template(model: @model, other_profile_team_positions: @model.get("other_profile_team_positions"))
      OVLY.show(@$el, true, 400, 747, {classMod: "team-position-modal-holder team-position-edit-modal"})

      @$form = @$el.children("form")
      @initializeSelectors()


      allocations = @model.allocations()
      allocations.fetch
        success: (allocations) =>
          @allocationEditor = new TeamPositionAllocationEditorView
            collection: allocations
            el: @$('#position-allocation-editor')
          @allocationEditor.render()

    destroy: (e) ->
      positions = @options.parentView.team().positions
      positions.fetch
        success: =>
          @view = new TeamPositionCormfirmDestroyView
            collection: positions
            model: @model
          OVLY.show ''
          OVLY.show @view.render().el, true, 526, 420

    initializeSelectors: ->
      @initializeParentSelector()
      @initializeJobTitleDiv()
      @initializeEmployeeSelector()
      @initializeOpenPositionFields()

    initializeParentSelector: ->
      options = ["<option value=null> Make Root </option>"]

      for model in @model.collection.validParents(@model)
        options.push "<option value=#{model.get('id')}>#{model.orgChartOptionView()}</option>"
      @$el.find("form #parent_id").html(options.join(''))
      @$el.find("form #parent_id").val @model.get("parent_id")

    initializeJobTitleDiv: (job_title_id, isAssigned)->
      job_title_id ?= @model.get("job_title_id")
      isAssigned ?= @model.isAssigned()

      html = @jobTitles.map((job_title)->
        "<option value=#{job_title.get('id')}>#{job_title.get('title')}</option>"
      ).join('')
      @$el.find("form #job_title_id").html html
      @$el.find("form #job_title_id").val job_title_id
      @$el.find("form #job_title").html @model.get('title')
      if isAssigned
        @$el.find("form #job_title_id").hide()
        @$el.find("form #job_title").show()
        @$el.find('form #open-position-fields').hide()
      else
        @$el.find("form #job_title").hide()
        @$el.find("form #job_title_id").show()
        @$el.find('form #open-position-fields').show()

    initializeEmployeeSelector: ->
      input = @$el.find("#profile_id")

      input_widget_options =
        theme: "namely"
        tokenLimit: 1
        onResult: Utils.convertObjectsToTokens

        onAdd: (item)=>
          @initializeJobTitleDiv(item["job_title_id"], true)
          @resetStartDate()
        onDelete: (item)=>
          @initializeJobTitleDiv(@model.get("job_title_id"), false)
          @resetStartDate()

      input.tokenInput("/people?search_type=add_to_team", input_widget_options)
      if @model.isAssigned()
        @$el.find('#profile_id').tokenInput('add', {id: @model.get('profile_id'), name: "#{@model.get('full_name')} – #{@model.get('title')}"})
        @$("#start_date").val(@model.get("start_date"))

    initializeOpenPositionFields: ->
      @$el.find("form #bonus").val(@model.get('bonus'))
      @$el.find("form #salary").val(@model.get('salary'))
      @$el.find("form #requisition_number").val(@model.get('requisition_number'))
      @$el.find("form #position_type").val(@model.get('position_type'))
      @$el.find("form #predicted_date_filled").val(@model.get('predicted_date_filled'))

    resetStartDate: ->
      @$("#start_date").val(@$("#start_date").attr('data-reset'))

    formModelAttributes: ->
      ["start_date", "profile_id", "job_title_id", "parent_id", "salary", "bonus", "requisition_number", "position_type", "predicted_date_filled"]

    isChanged: ->
      params = @getFormData()
      (_.all(@formModelAttributes, (attr) => model.get(attr) == params(attr))) == false

    getFormData: ->
      params = {}
      for attr in @formModelAttributes()
        params[attr] = @$el.find('#' + attr).val()
      params

    gatherAllocationsHash: ->
      allocations = {}
      allocations['allocation_default'] = $("#allocation_default").val()
      allocations['allocation_dates']=[]
      allocations['allocation_values']=[]
      _.each( $(".allocation_row"), (row) ->
        allocations['allocation_dates'].push($(row).find('.allocation_date').val())
        allocations['allocation_values'].push($(row).find('.allocation_value').val())
      )
      allocations

    save: (e)->
      e.preventDefault()
      params = @model.attributes
      form_data = @getFormData()
      for attribute in @formModelAttributes()
        params[attribute] = form_data[attribute]
      params["allocations"] = @gatherAllocationsHash()

      @model.save(params,
        success: (resp)=>
          OVLY.hide()
        failure: =>
          console.log "failure"
        error: =>
          console.log "error")
