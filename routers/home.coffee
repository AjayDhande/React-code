define ['react',
        'backbone',
        'collections/event',
        'ui/events/announcement_form',
        'ui/events/events'], (React,
        Backbone,
        EventCollection,
        AnnouncementForm,
        Events) ->

  class HomeRouter extends Backbone.SubRoute
    routes:
      '': 'homePage'

    homePage: ->
      events = new EventCollection

      # react ui component
      if document.getElementById('update')
        React.renderComponent(
          AnnouncementForm(events: events),
          document.getElementById('update')
        )
      React.renderComponent(
        Events(events: events),
        document.getElementById('updates')
      )
