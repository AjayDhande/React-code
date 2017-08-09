define ['jquery', 'underscore', 'backbone', 'utils'], ($, _, Backbone, Utils ) ->

  class NotificationsView extends Backbone.View
    initialize: ->
      @$('.tokenizer_input').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          onResult: Utils.convertObjectsToTokens})
