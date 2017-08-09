define ['backbone',
        'collections/team_allocation'], (Backbone, TeamAllocationCollection) ->
  class PositionModel extends Backbone.Model
    defaults:
      # attributes used by the model in saving
      allocation: 100
      profile_id: null
      profile: null
      dotted_lines_reports: []
      start_date: null
      start_date_s: null
      parent_id: null
      # these attributes are used in the view, but will not be saved
      # parent_full_name: null
      title: null
      job_title_id: null
      default_id_select: null
      #profile information
      assigned: false
      personal_email: "test"
      mobile_phone: null
      office_phone: null
      full_name: "test"
      image_large: null
      last_review_date_s: null
      last_raise_date_s: null
      bio: ""
      url: null

    initialize: (attributes, options) ->
      if @isNew()
        d = new Date()
        @start_date = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate()
      @markToRevert()

    isDefault: ->
      (@full_name == "test")

    children: ->
      @collection.childrenOf(@)

    ancestors: ->
      @collection.ancestorsOf(@)

    parent: ->
      @collection.get(@get('parent_id'))

    isRoot: ->
      @get('parent_id') == null || @get('parent_id') == undefined

    isAssigned: ->
      @get("profile_id") != null && @get("profile_id") != undefined

    level: (levelCache=0)->
      if @isRoot() || !@parent()
        levelCache
      else
        @parent().level(levelCache + 1)

    profileUrl: ->
      if @get("assigned")
        "/people/"+@get("profile_id")
      else
        "javascript:;"

    orgChartOptionView: ->
      (new Array(@level() + 1).join('&nbsp;&nbsp;')) + ( if (@level() > 0) then "↳ " else " ") + @get("full_name")

    markToRevert: ->
      @_revertAttributes = _.clone(@attributes)

    revert: ->
      if @_revertAttributes
        @set @_revertAttributes,
          silent: true

    job_title: ->
      @get('title')

    set: (attributes, options)->
      if attributes["parent_id"] == "null"
        attributes["parent_id"] = null
      super(attributes, options)

    moveChildren: (newParentID, options) ->
      newParentID = parseInt(newParentID)
      options = _.extend {}, options,
        url: @url() + '/move_children'
        dataType: 'json'
        type: 'PUT'
        data:
          parent: newParentID

      $.ajax options

      _.each(@children(), (child) =>
        child.set('parent_id', newParentID)
      )

    allocations: ->
      new TeamAllocationCollection(position: @, team: @collection.team)
    daysExperience: ->
      date_difference = new Date() - new Date(@get('start_date'))
      console.log "daysExperience"
      if date_difference > 0
        Math.floor(date_difference / (1000*60*60*24))
      else
        null

    daysExperienceString: (full)->
      if @daysExperience() == 1
        if full
          "Experience: 1 Day"
        else
          "1 Day"
      else
        if full
          if @daysExperience() > 0
            "Experience: #{@daysExperience()} Days"
          else
            "Experience: 0 Days"
        else
          if @daysExperience() > 0
            "#{@daysExperience()} Days"
          else
            "0 Days"

