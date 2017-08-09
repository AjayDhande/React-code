define ['jquery', 'underscore', 'backbone',
        'views/components/editable_item'], ($, _, Backbone,
        EditableItemView) ->

  class OfficeEditableItemView extends EditableItemView
    handleOrphans: false
    renderForm: ->
      @form = new Backbone.Form(model: @model).render()
      @form.on 'country_id:change', (form, countryEditor)=>
        subdivisions = Namely.countries.get(countryEditor.getValue()).subdivisions()
        form.fields.state_id.editor.setOptions(subdivisions)

      @$el.html(@form.render().el)

      subdivisions = Namely.countries.get(@model.get('country_id')).subdivisions()
      @form.fields.state_id.editor.setOptions(subdivisions)


