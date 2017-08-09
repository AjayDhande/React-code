define ['jquery', 'underscore', 'backbone',
        'templates/team/team_positions/confirm_destroy'], ($, _, Backbone, template) ->
  class TeamPositionCormfirmDestroyView extends Backbone.View
    events:
      "click #destroy-team-position": "destroy"

    template: template

    render: ->
      @$el.parent().addClass 'team-confirm-destroy'
      @$el.html @template
        model: @model
        collection: @collection
        selectList: @collection.validParents(@model)
        team: @collection.team
      @

    destroy: (e) ->
      e.preventDefault()
      e.stopPropagation()
      parent = $('#select-orphaned').val()
      destroy = =>
        @model.destroy
          success: @onDestroy
          error: @onDestroyError

      if parent? && parent > 0
        @model.moveChildren parent, success: destroy
      else
        destroy()

    onDestroy: (team, jqXHR) =>
      OVLY.hide true
      @collection.destroyPosition(@model)

    onDestroyError: (team, jqXHR) ->
      console.log "could not destroy :(", $.parseJSON(jqXHR.responseText)
