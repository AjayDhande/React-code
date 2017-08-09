define ['jquery', 'underscore', 'backbone', 'utils'], 
($, _, Backbone, Utils) ->

  class NotificationView extends Backbone.View
    el: '#dropdown_notifications'
