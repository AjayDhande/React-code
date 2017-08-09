define ['backbone',
        'backbone.relational',
        'moment',
        'models/event_comment',
        'collections/event_comments',
        'models/announcement'], (Backbone,
        BackboneRelational,
        moment,
        EventCommentModel,
        EventCommentsCollection,
        AnnouncementModel) ->

  class EventModel extends Backbone.RelationalModel

    urlRoot: '/events'

    relations: [
      {
        type: Backbone.HasMany
        key: 'comments'
        relatedModel: EventCommentModel
        collectionType: EventCommentsCollection
        reverseRelation:
          key: 'parent'
          includeInJSON: 'id'
      }
    ]

    day: ->
      # TODO: consider the user's timezone
      moment(@get('created_at') * 1000).format('MMMM Do')

    announcement: ->
      if @get('type') == 'announcement'
        @_announcement ?= new AnnouncementModel(@get('announcement'))
      else
        null
