define ['jquery', 'underscore', 'backbone', 'overlay',
        'templates/components/confirm_destroy'], ($, _, Backbone, OVLY, confirmTemplate) ->
  class ConfirmDestroyView extends Backbone.View
    events:
      "click .button-remove": "delete"
      "click .cancel": "cancel"
    template: confirmTemplate
    render: ->
      args =
        title: (@model.get('title') || @model.toString())
        orphanOptions: (if @model.orphans then @model.orphans(@model.collection) else @model.collection)
        forceOrphans: @options.forceOrphans
        model: @model
        abandonOrphans: @model.abandonOrphans

      @$el.html(@template(args))
      OVLY.show(@el, false, 526, 420)
      @

    delete: (e) ->
      e.preventDefault()
      e.stopPropagation()
      @model.destroy
        data: $.param(orphaned_to: @$('select[name=orphaned_to]').val())
        wait: true
        success: @onDestroy
        error: @onDestroyError

    cancel: ->
      OVLY.hide()

    onDestroy: (model, xhr) ->
      OVLY.hide()

    onDestroyError: (model, xhr) ->
      alert("Could not destroy: #{ $.parseJSON(xhr.responseText).message }")
      OVLY.hide()

