define ['jquery', 'underscore', 'backbone',
        'collections/currency_type',
        'collections/division',
        'collections/team_category',
        'templates/teams/form'], ($, _, Backbone,
        CurrencyTypeCollection,
        DivisionCollection,
        TeamCategoryCollection,
        formTemplate) ->
  class TeamEditView extends Backbone.View
    template: formTemplate
    dateOpts:
      dateFormat: 'yy-mm-dd'
      changeMonth: true
      changeYear: true

    events:
      "submit #team-form": "save"
      "click .cancel": "cancel"

    initialize: ->
      Namely.currencyTypes ?= new CurrencyTypeCollection
      if !Namely.currencyTypes.length
        Namely.currencyTypes.fetch async: false
      Namely.divisions ?= new DivisionCollection
      if !Namely.divisions.length
        Namely.divisions.fetch async: false
      Namely.teamCategories ?= new TeamCategoryCollection
      if !Namely.teamCategories.length
        Namely.teamCategories.fetch async: false

      @error_template = _.template($("#form-errors").html())
      _.bindAll @, "onSave", "onSaveError", "render"
      @model.bind "change:errors", @render

    serialize: ->
      serialized = _.object(_.map($('#team-form').serializeArray(), (element) ->
        [element.name, element.value]))
      team_categories = []
      @$('#team-categories-list .category').each (index, category) ->
        team_categories.push($(category).data('id')) if $(category).hasClass('active')
      serialized.team_category_ids = team_categories.toString()
      serialized

    save: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @model.save @serialize(),
        success: @onSave
        error: @onSaveError

    onSave: (team) ->
      window.location.href = @model.url()

    onSaveError: (team, jqXHR) ->
      @model = team
      @model.set errors: $.parseJSON(jqXHR.responseText)

    cancel: (e) ->
      e.preventDefault()
      Backbone.history.navigate "teams", {trigger: true}

    render: (team) ->
      if team?
        @$("#errors").html @error_template(model: @model.toJSON())
        @$("[id$=_wrap]").each ->
          $(@).removeClass("errors").find(".errors").remove()

        errors = @model.get("errors")
        key = undefined
        error_text = undefined
        for key of errors
          error_text = "<p class=\"errors\">" + errors[key].join("<br/>") + "</p>"
          @$("#" + key + "_wrap").addClass("error").append error_text
      else
        @$el.html @template(
          model: @model.toJSON()
          collection: @collection
          categories: Namely.teamCategories
          divisions: Namely.divisions
          team_statuses: Namely.team_statuses
          can_team_add_remove_teams: Namely.can_team_add_remove_teams
          currencies: Namely.currencyTypes
        )
        $form = @$("form")
        $form.find(".date").datepicker @dateOpts
        $form.find("input[name=status]:first").attr "checked", true
        $form.find(".custom-check").customCheck()
      @
