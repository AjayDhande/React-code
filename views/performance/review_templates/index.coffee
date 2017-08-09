define ['jquery', 'underscore', 'backbone', 'overlay', 'jquery.tablesorter'], ($, _, Backbone, OVLY) ->
  class ReviewTemplateIndexView extends Backbone.View
    initialize: ->
      $('table#review-templates').tablesorter()
      $('.preview').click (e) ->
        e.preventDefault()
        target = $(e.currentTarget)
        OVLY.showURL(target.attr('href'), 675, 400)
