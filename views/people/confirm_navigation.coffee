define ['jquery', 'backbone', 'overlay',
        'templates/people/confirm_navigation'], ($, Backbone, OVLY, template) ->
  class ConfirmNavigationView extends Backbone.View
    template: template
    events:
      'click .cancel': 'closeCancel'
      'click .continue-and-save': 'continueAndSave'

    initialize: ->
      _.bindAll(@, 'closeCancel', 'continueAndSave')

    closeCancel: (e) ->
      e.preventDefault()
      e.stopPropagation()
      OVLY.hide()

    continueAndSave: (e) ->
      e.preventDefault()
      e.stopPropagation()
      $('#continue_and_save').val(this.options.targetSection)
      OVLY.hide()
      validator = $("#employee-form").validate()
      if validator.form()
        $('#employee-form').trigger("submit")

    render: ->
      @$el.html @template
        targetSection : @options.targetSection
        targetHref : @options.targetHref
        targetGuid : @options.targetGuid
        statusChange : @options.statusChange
      OVLY.show(@el, true, 500, 300)
      @
