define ['jquery', 'underscore', 'backbone',
        'templates/import/import_row'], ($, _, Backbone, template) ->
  class ImportRowView extends Backbone.View
    render: ->
      ret = []
      template(values: @model.get('values'))

