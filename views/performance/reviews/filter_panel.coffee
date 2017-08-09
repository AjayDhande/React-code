define ['jquery', 'underscore',
        'views/components/tool_panel'], ($, _,
        ToolPanelView) ->
  class ReviewsFilterPanelView extends ToolPanelView
    el: '#reviews-filters'

    events:
      'click button.search': 'search'
      'change select': 'selected'

    initialize: ->
      super
      @updateCounter()

    serialized: ->
      q: @$('input[name="name"]').val()
      team: @$('select[name="team"]').val()
      title: @$('select[name="title"]').val()
      review_group: @$('select[name="review_group"]').val()
      office: @$('select[name="office"]').val()
      performance: @$('select[name="performance"]').val()
      status: @$('select[name="status"]').val()
      type: @$('select[name="type"]').val()
      divisions: @serializeDivisions()

    updateCounter: ->
      count = @collection.count
      if count < 2
        @$('.count').html("#{count} Result")
      else
        @$('.count').html("#{count} Results")

    search: (e) ->
      e.preventDefault()
      @collection.filterAndFetch(@serialized()).done(=> @updateCounter())

    selected: (e) ->
      target = $(e.currentTarget)
      if target.val()
        target.addClass('selected')
      else
        target.removeClass('selected')

    serializeDivisions: ->
      divisions = []
      _.map $(".divisions"), (division) ->
        divisions.push($(division).val()) if $(division).val()
      divisions
