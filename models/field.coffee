define ['backbone', 'backbone-forms-list'], (Backbone) ->
  class FieldModel extends Backbone.Model
    basicSchema:
      label: title: 'Label', type: 'Text', validations: ['required']
    nonDefaultSchema:
      type_id: type: 'Select', title: 'Type', validations: ['required'], options: (callback) -> callback(Namely.fieldTypes)
    extraSchema:
      select:
        choices: type: 'List'
      checkboxes:
        choices: type: 'List'

    schema: ->
      schema = _.extend {}, @basicSchema

      if @isNew()
        _.extend schema, @nonDefaultSchema

      if !@get('is_default') && @extraSchema[@get('type_id')] 
        _.extend schema, @extraSchema[@get('type_id')]

      schema

    toJSON: ->
      id: @id
      label: @get('label')
      type_id: @get('type_id')
      choices: @get('choices')
      section_id: @get('section_id')
      block_index: @get('block_index')
      field_index: @get('field_index')
      is_default: @get('is_default')
      name: @get('name')

    toString: ->
      @get('label')
