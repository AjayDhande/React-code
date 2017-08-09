define ['jquery', 'underscore', 'backbone',
  'templates/skilltag/form_tag'], ($, _, Backbone, SkillTagTemplate) ->
  class SkillTagView extends Backbone.View
    events:
      'click .close': 'close'

    template: SkillTagTemplate

    initialize: (options) ->
      @container = options.container
      @render()
    

    close: (e) ->
      e.preventDefault()
      @$el.remove()

    render: ->
      @$el = $(this.template({
          skilltag: @model.toJSON()
        })).appendTo(@container)
      @



