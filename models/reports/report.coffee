define ['jquery', 'backbone', 'collections/reports/column'], ($, Backbone,
    ColumnCollection) ->
  class ReportModel extends Backbone.Model
    url: ->
      "/reports/#{ @id }"

    results: (update = false) ->
      dfd = $.Deferred()
      if update || !@_results?
        $.ajax(@url() + '/results',
          type: 'GET'
          dataType: 'json'
        ).done (results) =>
          @_results = results
          @trigger('results', results)
          dfd.resolve(results)
      else
        dfd.resolve(@_results)
      dfd.promise()

    addColumns: (columnIds) ->
      @set('columns', @get('columns').concat(columnIds))
      @save()

    removeColumnIndex: (index) ->
      columns = @get('columns')
      columns.splice(index, 1)
      @set('columns', columns)
      @save()

    removeFilterIndex: (index) ->
      filters = @get('filters')
      filters.splice(index, 1)
      @set('filters', filters)
      @save()

    addFilter: (newFilter) ->
      @set('filters', @get('filters').concat([newFilter]))
      @save()
      @

    getFilterValueString: (filter)->
      availableFilter = @findFilter(filter)

      if availableFilter?
        if availableFilter.get('filter_choices')
          availableFilter.get('filter_choices')[filter.value]
        else
          filter.value
      else
        'NOT FOUND'

    getFilterOperatorString: (filter)->
      availableFilter = @findFilter(filter)
      
      if availableFilter? && availableFilter.get('filter_choices')?
        ''
      else
        filter.operator

    findFilter: (filter)->
      _.find(@availableFilters().models, (model)-> 
        model.get('name') == filter.name)

    toJSON: ->
      id: @id
      title: @get('title')
      columns: @get('columns')
      filters: @get('filters') || []

    availableColumns: ->
      @_availableColumns ?= new ColumnCollection(@get('available_columns'))
    
    availableFilters: ->
      @_availableFilters ?= new ColumnCollection(@get('available_filters'))

      # if @_availableFilters?
      #   @_availableFilters
      # else
      #   $.ajax(@url(),
      #     async: false,
      #     type: 'GET', 
      #     {data: {include_filters: true}, 
      #     success: =>
      #       @_availableFilters ?= new ColumnCollection(@get('available_filters'))
      #     })
      # @_availableFilters











