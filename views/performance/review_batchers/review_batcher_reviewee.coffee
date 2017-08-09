define ['jquery', 'underscore', 'backbone',
        'templates/performance/review_batchers/reviewee'], ($, _, Backbone, template) ->
          
          
  class ReviewBatcherRevieweeView extends Backbone.View
    template: template
    
    events: 
      'click .delete': 'deleteReviewee'
    
    initialize: (options) ->
      @container = options.container
      @reviewee = options.model
      @holder_view = options.holder_view
      @render()

    
    render: ->
      @$el = $(@template({
          name: @reviewee.get('name'),
          id: @reviewee.get('id'),
          reports_to: @reviewee.get('reports_to'),
          reports_to_reports_to: @reviewee.get('reports_to_reports_to'),
          guid: @reviewee.get('guid'),
        })).appendTo(@container)
    
    deleteReviewee: ->
      @reviewee.destroy
        success: =>
          @holder_view.displayReviewees()
      