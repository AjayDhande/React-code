define ['react',
        'backbone',
        'models/event',
        'ui/events/event'], (React,
        Backbone,
        EventModel,
        Event) ->

  class EventsRouter extends Backbone.SubRoute

    routes:
      ':id': 'show'

    show: (id) ->
      React.renderComponent(
        Event(
          event: new EventModel(id: id)
          standalone: true
        ),
        document.getElementById('event')
      )
