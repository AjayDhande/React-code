define ['jquery', 'underscore', 'backbone',
        'views/components/confirm_destroy',
        'templates/components/editable_item'], ($, _, Backbone,
        ConfirmDestroyView,
        editableItemTemplate) ->
  class EditableItemView extends Backbone.View
    template: editableItemTemplate
    form: null
    events:
      'click .edit': 'edit'
      'click .delete': 'delete'
      'click .cancel': 'cancel'
      'submit form': 'save'
    forceOrphans: false

    initialize: (options) ->
      @model.on('destroy', => @remove())

    save: (e) ->
      e.preventDefault()
      @form.commit()
      @model.save null, success: => @render()

    edit: (e)->
      e.preventDefault()
      @renderForm()

    delete: (e) ->
      e.preventDefault()
      new ConfirmDestroyView(
        model: @model,
        forceOrphans: @forceOrphans
      ).render()

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

    renderForm: ->
      @form = new Backbone.Form
        model: @model
      @$el.html(@form.render().el)
      @$('input[type="checkbox"]').addClass('custom-check').customCheck()
      @$("input[name='years_until_active']").attr('min', 0)
      @$("input[name='days_off']").attr('min', 0)
