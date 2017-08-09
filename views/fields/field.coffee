define ['jquery', 'underscore', 'backbone',
        'views/fields/confirm_destroy',
        'templates/fields/field',
        'templates/fields/field_form',
        'backbone-forms-list', 'backbone-forms-templates'], ($, _, Backbone,
    FieldsConfirmDestroyView, template, fieldFormTemplate) ->
  class FieldView extends Backbone.View
    template: template
    tagName: 'li'
    className: 'field'
    events:
      'sorted': 'sorted'
      'updatedIndex': 'updatedIndex'
      'click .cancel': 'cancel'
      'submit form': 'save'
      'click .edit': 'edit'
      'click .remove': 'delete'
      'change select[name="type_id"]': 'changeType'

    initialize: (options) ->
      @model.on('destroy', => @remove())

    sorted: (e, sectionId, blockIndex) ->
      @model.set('section_id', sectionId)
      @model.set('block_index', blockIndex)
      @$el.parents('.section').find('li.field').each (index, element) ->
        $(element).trigger('updatedIndex', [index])

    updatedIndex: (e, index) ->
      @model.set('field_index', index)

    save: (e) ->
      e.preventDefault()
      @form.commit()
      @model.save null,
        success: => @render()
        error: _.bind(@showError, @)

    edit: (e) ->
      e.preventDefault()
      @renderForm()

    delete: (e) ->
      e.preventDefault()
      new FieldsConfirmDestroyView(model: @model).render()

    changeType: (e) ->
      type = $(e.currentTarget).val()
      @model.set('label', @$('input[name="label"]').val())
      @model.set('type_id', type)
      @render()


    cancel: (e) ->
      e.preventDefault()
      if @model.id
        @render()
      else
        @model.destroy()
        @remove()

    render: ->
      if @model.id
        @$el.data('id', @model.id)
        @$el.html(@template(@model.toJSON()))
      else
        @renderForm()
      @

    showError: (model, xhr, options) ->
      errors = jQuery.parseJSON(xhr.responseText)
      _.each errors, (error, key) =>
        if key == 'name'
          key = 'label'
        else if key == 'settings'
          key = 'choices'

        @form.fields[key].setError(error[0])
      console.log(xhr)
      console.log(options)

    renderForm: ->
      @form = new Backbone.Form(
        template: fieldFormTemplate
        model: @model
      )

      @$el.html(@form.render().el)
