define ['backbone', 'jquery', 'views/time_off_requests/index', 
'views/time_off_requests/new', 'views/time_off_requests/sidebar',
'views/time_off_requests/edit'], 
(Backbone, $, TimeOffRequestView, TimeOffRequestCreate, TimeOffSidebarView,
  TimeOffRequestEditView) ->
  class TimeOffRequestRouter extends Backbone.SubRoute

    routes:
      '': 'timeOffRequestIndex'
      'new': 'timeOffRequestCreate'
      ':id/respond' : 'respond'
      ':id/edit' : 'edit'
      'upcoming': ''

    timeOffRequestIndex: ->
      time_off_request = new TimeOffRequestView()
      time_off_request.render()
      new TimeOffRequestCreate

    timeOffRequestCreate: ->
      new TimeOffRequestCreate
      sidebar = new TimeOffSidebarView

    edit: ->
      $('.request_answer').click =>
        if window.parent
          window.parent.location.reload()
      sidebar = new TimeOffSidebarView(id: Backbone.history.fragment.substring(18, Backbone.history.fragment.length).replace(/[^\d.]/g, ""))
      new TimeOffRequestEditView
      @$el.find('.date').datepicker(@dateOpts)
      @$el.find('.spinner').spinner(@spinnerOpts)

    respond: ->
      $('.request_answer').click =>
        if window.parent
          window.parent.location.reload()
      sidebar = new TimeOffSidebarView(id: Backbone.history.fragment.substring(18, Backbone.history.fragment.length).replace(/[^\d.]/g, ""))
      $('input[type="submit"]').click (e) =>
        if (e.target.name == 'approve')
          $('#time_off_request_approved').val('true')
        else
          $('#time_off_request_approved').val('false')