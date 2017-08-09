define ['backbone', 'jquery', 'views/personal_calendar/index'], (Backbone, $, PersonalCalendarView) ->
  class PersonalCalendarRouter extends Backbone.SubRoute

    routes:
      '': 'personalCalendarIndex'

    personalCalendarIndex: ->
      personal_calendar = new PersonalCalendarView()
      personal_calendar.render()