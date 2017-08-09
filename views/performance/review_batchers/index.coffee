define ['jquery', 'underscore', 'backbone', 'jquery.tablesorter'], ($, _, Backbone, Utils) ->
  class ReviewBatcherIndexView extends Backbone.View
    initialize: ->
      $('table#actionable-batch-reviews').tablesorter()
