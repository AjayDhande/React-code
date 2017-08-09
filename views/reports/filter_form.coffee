define ['jquery', 'underscore', 'backbone',
        'templates/reports/form_fields',
        'templates/reports/form_operator'], ($, _, Backbone,
        fieldTemplate, operatorTemplate) ->
  class ReportFilterFormView extends Backbone.View
    el: '#filter_form'
    events:
      'change select[name="field"]': 'updateField'
      'submit': 'submit'

    initialize: ->
      @reset()

      @model.on 'sync', @render, @


    render: ->
      @renderField()
      if @field?
        @renderOperator()

    renderField: ->
      @$field.html(fieldTemplate(columns: @model.get('columns'),
                                 report: @model))
      @$('select[name="field"]').select2
        dropdownAutoWidth: true

    renderOperator: ->
      @$operator.html(operatorTemplate(filter: @filter, field: @field))

    updateField: ->
      @field = @model.availableFilters().get(@$('select[name="field"]').val())
      @filter.name = @field.id
      @renderOperator()

    updateFilter: ->
      $operator = @$('select[name="operator"]')
      if $operator.length
        @filter.operator = $operator.val()
      $value = @$('select[name="value"]')
      if $value.length
        @filter.value = $value.val()

    submit: (e) ->
      e.preventDefault()
      @filter.operator = @$('select[name="operator"]').val()
      @filter.value = @$('input[name="value"]').val()
      @model.addFilter(@filter)
      @reset()

    reset: ->
      @filter = {name: null, operator: null}
      @field = null
      @$field = $("#filter_field").empty()
      @$operator = $("#filter_operator").empty()
