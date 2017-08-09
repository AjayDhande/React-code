define ['jquery', 'underscore', 'backbone',
    'templates/scopes/form', 'templates/scopes/form_values', 'utils'], ($, _, Backbone,
    template, templateValues, Utils) ->
  class ScopeFormView extends Backbone.View
    events:
      'change .scope-field': 'setField'
      'change .scope-value': 'setValue'
      'submit form': 'save'

    defaultFields: [
      { value: 'job_title', name: 'Job Title' },
      { value: 'office_location', name: 'Office' },
      { value: 'guid', name: 'Profile' },
      { value: 'start_date_month', name: 'Tenure (months)' }
    ]

    render: ->
      @$el.html(template(model: @model, addLabel: @options.addLabel, fields: @options.fields || @defaultFields))
      @

    renderValueForm: ->
      @$('.container-values').html(templateValues(model: @model))
      @$('.tokenizer_input').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          tokenLimit: 1
          onResult: Utils.convertObjectsToTokens})

    renderValueError: ->
      @$('.container-values').html("Error happened.")

    setField: (e) ->
      select = $(e.currentTarget)
      select.removeClass('default')
      field = select.val()
      if field == 'start_date_month'
        @model.set('field', 'start_date')
        @model.set('operator', '~m<=')
      else
        @model.set('field', field)
        select.addClass('default') unless field
      @model.fetchFieldValues().then(
        _.bind(@renderValueForm, @),
        _.bind(@renderValueError, @))

    setValue: (e) ->
      select = $(e.currentTarget)
      value = select.val()
      if value
        select.removeClass('default')
      else
        select.addClass('default')
      @model.set('value', value)
      @$('button.create-criteria').show()

    save: (e) ->
      e.preventDefault()
      if @model.get('value') != ""
        @trigger('save')
