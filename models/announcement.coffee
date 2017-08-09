define ['backbone',
        'backbone.relational'], (Backbone,
        BackboneRelational) ->

  class AnnouncementModel extends Backbone.Model

    urlRoot: '/announcements'

    parse: (response) ->
      response.announcement
