define ['jquery', 'underscore', 'backbone',
        'views/components/editable_item',
        'templates/time_off/editable_item'], ($, _, Backbone,
        EditableItemView, template) ->
  class TimeOffModifierItemView extends EditableItemView
    template: template

    render: ->
      if @model.id
        @$el.data('id', @model.id)
        modelData = @model.toJSON()
        modelData.type = Namely.timeOffTypes.get(modelData.time_off_type_id).get('title')
        @$el.html(@template(modelData))
      else
        @renderForm()
      @
