define ['jquery', 'backbone',
        'templates/fields/field_block'], ($, Backbone, template) ->
  class FieldBlockView extends Backbone.View
  template: template
  form: null
  tagName: 'li'

  sorted: (e, index)->
    @$el.trigger('updated-sort', [@model, index])

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
