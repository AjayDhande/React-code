define ['underscore', 'backbone', 'overlay'
    'templates/time_off/reset',
    'templates/time_off/reset_results'], (_, Backbone, OVLY,
    ResetModal,
    ResetResults) ->
  class ResetModalView extends Backbone.View
    events:
      'click .approve-plan-reset': 'approve'
      'click .cancel-reset': 'cancel'

    initialize: (options)->
      @parentView = options.parentView
      @model = options.model
      @render()

    render: ->
      @$el.html ResetModal
      OVLY.show(@$el, true, 300, 500, {classMod: "reset-plan-modal"})

    approve: ->
      container = @$el
      container.html "<div class='loading'></div>"
      $.ajax
        type: 'PUT'
        url: '/time_off/plans/' + @model.id + '/reset'
        headers:
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        data:
          id: @model.id
        error: ->
          console.log "Error resetting plan."
        success: (data) ->
          container.html ResetResults
            data: data

    cancel: ->
      OVLY.hide()