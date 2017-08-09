define ['jquery', 'underscore', 'backbone',
        'models/time_off_summary', 'templates/time_off/sidebar'], ($, _, Backbone,
        TimeOffSummaryModel, template) ->
  class TimeOffSidebarView extends Backbone.View

    template: template
    el: '#time_off_sidebar'

    events:
      'click #next' : 'next'
      'click #previous' : 'previous'

    render: ->
      @$el.html @template(summary: $.parseJSON( @model.responseText ))

    initialize: ->
      @year = (new Date).getFullYear()
      @id = Backbone.history.fragment.substring(18, Backbone.history.fragment.length).replace(/[^\d.]/g, "")
      @id = 0 if @id == ""
      @fetch()

    next: ->
      $('.fade_wrap').fadeTo(50, 0.1)
      @year++
      @fetch()
      $('.fade_wrap').fadeTo(50, 1)

    previous: ->
      $('.fade_wrap').fadeTo(50, 0.1)
      @year--
      @fetch()
      $('.fade_wrap').fadeTo(50, 1)

    fetch: ->
      @model = new TimeOffSummaryModel(id: @id, year: @year).fetch
        success: =>
          @render()
          @$el.fadeIn(300)
