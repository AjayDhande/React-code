define ['jquery', 'underscore', 'backbone',
        'views/components/tool_panel',
        'templates/reports/filter_form',
        'templates/reports/filter_list'], ($, _, Backbone,
        ToolPanelView, templateForm, templateList) ->
  class ReportFilterPanelView extends ToolPanelView
    el: '#report-filters'
    events:
      'change select[name="column"]': 'selectField'
      'submit form': 'submit'
      'click .delete': 'removeFilter'

    initialize: ->
      super
      @reset()
      @model.on('sync', @renderForm, @)
      @model.on('sync', @renderList, @)

    renderForm: ->
      @$('.filter-form').html(
        templateForm(
          columns: @model.availableFilters(),
          report: @model,
          column: @column,
          filter: @filter
        )
      )

    renderList: ->
      if @model.get('filters').length == 0
        @$('.tool-counter').text('')
        @$('.tool-counter').addClass('blank-counter')
      else
        @$('.tool-counter').text(@model.get('filters').length)
        @$('.tool-counter').removeClass('blank-counter')
      @$('.filter-list').html(templateList(report: @model))

    selectField: (e) ->
      selectedFilterName = @$('select[name="column"]').val()
      @filter.name = selectedFilterName
      @column = @model.availableFilters().get(selectedFilterName)
      @renderForm()

    reset: ->
      @filter = {name: null, operator: null}
      @column = null

    submit: (e) ->
      e.preventDefault()
      @filter.operator = @$('[name="operator"]').val()
      @filter.value = @$('[name="value"]').val()
      @model.addFilter(@filter)
      @reset()
      @renderForm()
      @renderList()

    removeFilter: (e) ->
      e.preventDefault()
      @model.removeFilterIndex($(e.currentTarget).data('filter_index'))
