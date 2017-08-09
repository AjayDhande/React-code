define ['jquery', 'backbone',
  'collections/job_title',
  'collections/office',
  'collections/person'], ($, Backbone,
  JobTitleCollection,
  OfficeCollection,
  PersonCollection) ->

  class FilterModel extends Backbone.RelationalModel
    defaults:
      filter_type: 'job_title'
      operator: '='
      value: ''

    initialize: ->
      @on 'change:field', _.bind(@setLabel, @)
      @on 'change:value', _.bind(@setTitle, @)

    fetchFieldValues: ->
      deferred = $.Deferred()
      collectionClass = switch @get('field')
        when 'job_title' then JobTitleCollection
        when 'office_location' then OfficeCollection
        when 'guid' then PersonCollection

      if collectionClass
        @valueCollection = new collectionClass
        @valueCollection.fetch(data: {limit: 5000}, reset: true).then(
          ( => deferred.resolve(@valueCollection)),
          ( -> deferred.reject()))
      else
        @valueCollection = null
        deferred.resolve()

      deferred

    setLabel: ->
      @set 'label', @label() if @get('field')

    setTitle: ->
      if @get('field') == 'start_date'
        @set 'value_title', @get('value')
      else if @get('value') && @valueCollection
        @set 'value_title', @valueCollection.get(@get('value')).toString()

    label: ->
      switch @get('field')
        when 'job_title' then 'Job title'
        when 'office_location' then 'Office'
        when 'guid' then 'Profile'
        when 'start_date' then 'Tenure (months)'
        else @get('label')

    valueTitle: ->
      if @get('field') == 'start_date'
        @get('value')
      else
        @get('value_title')
