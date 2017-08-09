define ['jquery', 'underscore', 'backbone',
        'models/field',
        'views/fields/field',
        'templates/fields/section'], ($, _, Backbone,
        FieldModel,
        FieldView, template) ->
  class SectionView extends Backbone.View
    template: template

    events:
      'updated-sort': 'updatedSort'
      'click .add-field': 'addField'
      'click .add-block': 'addBlock'
      'click h5': 'editBlockTitle'

    initialize: (options) ->
      @allFields = options.fields
      @fields = @allFields.inSection(@model.id)
      @fieldViews = []
      @fields.each (field) =>
        @fieldViews.push(new FieldView(model: field))

    updatedSort: (e, model, position) ->
      @model.fields().remove(model)

      #@model.fields().each (model, index) ->
      #  ordinal = index
      #  if index >= position
      #    ordinal += 1
      #  model.set('ordinal', ordinal)

      #model.set('ordinal', position)
      @model.fields().add(model, {at: position})

    editBlockTitle: (e)->
      saveTitle = (e)=>
        @model.get('block_titles')[blockIndex] = $input.val()
        @model.save()
        $input.replaceWith($('<h5>').text($input.val()))
      e.preventDefault()
      $element = $(e.currentTarget)
      title = $element.text()
      blockIndex = $element.data('block-index')
      $input = $('<input>', value: title, name: "block-#{ blockIndex }", class: 'edit-title')
      $input.keypress (e) =>
        if e.which == 13
          saveTitle(e)
      $input.blur saveTitle
      $element.replaceWith($input)
      $input.focus()

    render: ->
      @$el.html(@template(@model.toJSON()))
      $defaultContainer = @$("#fields-#{ @model.id }-0")
      _.each @fieldViews, (fieldView) =>
        $container = @$("#fields-#{ @model.id }-#{ fieldView.model.get('block_index') }")
        if $container.length
          $container.append(fieldView.render().el)
        else
          $defaultContainer.append(fieldView.render().el)

      @$('.fields').sortable
        placeholder: "ui-state-highlight"
        opacity: 0.7
        connectWith: '.fields'
        stop: (event, ui) ->
          sectionId = ui.item.parent().data('section-id')
          blockIndex = ui.item.parent().data('block-index')
          ui.item.trigger('sorted', [sectionId, blockIndex])

      @$el

    addField: (e) ->
      e.preventDefault()
      field_index = @fields.inBlock(0).maxFieldIndex() + 1
      field = new FieldModel
        block_index: @model.get('block_titles').length - 1
        section_id: @model.id
        field_index: field_index
        is_default: false

      @allFields.push(field)
      @fields.push(field)
      fieldView = new FieldView(model: field)
      @$("#fields-#{ @model.id }-#{ field.get('block_index') }").append(fieldView.render().el)
    
    addBlock: (e) ->
      e.preventDefault()
      @model.get('block_titles').push('')
      @model.save null,
        success: =>
          @render()

