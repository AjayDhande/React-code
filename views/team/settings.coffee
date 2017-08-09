define ['backbone', 'utils'], (Backbone, Utils) ->
  class TeamSettingsView extends Backbone.View
    initialize: ->
      Utils.setupDatePicker()
      $('button.update-team').click(@save)
      $('button.update-team').submit(@save)

    serialize: ->
      serialized = _.object(_.map($('.edit-form').serializeArray(), (element) -> [element.name, element.value]))
      team_categories = []
      $('#team-categories-list .category').each (index, category) ->
        team_categories.push($(category).data('id')) if $(category).hasClass('active')
      serialized.team_category_ids = team_categories.toString()
      serialized

    onSave: (team) =>
      window.location.href = @model.url() + "/settings"

    onSaveError: (team, jqXHR) =>
      @model = team
      @model.set errors: $.parseJSON(jqXHR.responseText)

    save: (e) =>
      e.preventDefault()
      e.stopPropagation()
      @model.save @serialize(),
        success: @onSave
        error: @onSaveError
