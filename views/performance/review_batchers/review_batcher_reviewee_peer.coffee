define ['jquery', 'underscore', 'backbone',
        'templates/performance/review_batchers/reviewee_assigned_peer'], ($, _, Backbone, assigned_peer_template) ->
          
          
  class ReviewBatcherRevieweePeerView extends Backbone.View
    assigned_template: assigned_peer_template
    
    events: 
      'click .delete': 'deleteReviewee'
    
    initialize: (options) ->
      @container = options.container
      @peer = options.model
      @holder_view = options.holder_view
      @render()

    
    render: ->
      @$el = $(@assigned_template({
          name: @peer.get('name'),
          id: @peer.get('id'),
          guid: @peer.get('guid'),
          total_reviewers: @peer.get('total_reviewers'),
          total_assignments: @peer.get('total_assignments'),
          this_batch_assignments: @peer.get('this_batch_assignments'),
          this_batch_reviews: @peer.get('this_batch_reviews'),
        })).appendTo(@container)
    
    deleteReviewee: ->
      @peer.destroy
        success: =>
          @holder_view.display_peers()
      