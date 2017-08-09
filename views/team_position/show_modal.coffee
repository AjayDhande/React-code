define ['jquery', 'underscore', 'backbone', 'utils', 'overlay',
        'templates/team/org_chart_modals/show_modal'
        'models/position'], ($, _, Backbone, Utils, OVLY,
          showModalTemplate,
          PositionModel
          ) ->
  class TeamPositionShowModal extends Backbone.View

    initialize: (options)->
      @parentView = options.parentView
      @model = options.parentView.model

      @model.fetch(success: =>
        @render()
      )
    render: ->
      @$el.html showModalTemplate(
        model: @model,
        other_profile_team_positions: @model.get("other_profile_team_positions"))
      OVLY.show(@$el, true, 400, 320, {classMod: "team-position-modal-holder team-position-show-modal"})
