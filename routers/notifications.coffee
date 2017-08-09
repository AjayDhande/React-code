define ['backbone',
        'collections/notifications',
        'views/notifications/notification_dropdown'], (Backbone,
        NotificationsCollection, NotificationDropdownView) ->
  class NotificationRouter extends Backbone.Router
    initialize: ->
      @collection = new NotificationsCollection
      @view = new NotificationDropdownView
        collection: @collection

      @collection.fetch(reset: true)

