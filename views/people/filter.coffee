define ['views/components/item_filter'], (ItemFilterView) ->
  class PeopleFilterView extends ItemFilterView
    el: '#employees-filter'
    instantSearch: true
    searchField: '#employee-filter-search'

    initialize: ->
      @$('input.date').datepicker({ dateFormat: 'yy-mm-dd' })
      @collection.on("reset", =>
        $("#result-count").html(
          "#{@collection.getCount()} Result#{if @collection.getCount() == 1 then '' else 's'}"
          )
      )

      super()

    serializeForm: ->
      q: $('#employee-filter-search').val()
      team: $('#team').val()
      title: $('#title').val()
      tier: $('#tier').val()
      skill_tag: $('#skill_tag').val()
      status: $('#status').val()
      employee_type: $('#employee_type').val()
      divisions: @serializeDivisions()
      performance: $('#performance').val()
      office: $('#office').val()
      access_role: $('#access_role').val()

    serializeDivisions: ->
      divisionValues = {}
      _.map $(".divisions"), (division) ->
        $division = $(division)
        divisionValues[$division.data('category-id')] = $division.val()

      divisionValues
