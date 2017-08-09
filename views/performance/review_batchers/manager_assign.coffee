define ['jquery', 'underscore', 'backbone',
        'utils',
        'views/performance/review_batchers/review_batcher_reviewee_peer'
        'jquery.tokeninput'], ($, _, Backbone, Utils,
        ReviewBatcherRevieweePeerView) ->

  class ReviewBatcherManagerAssignView extends Backbone.View
    el: '#review_batcher_reviewee_manager_assign'

    assigned_peer_list: '#current_assigned_peers'
    form_add_assigned_peer: 'form#assign_peers'

    events:
      'click .publish': 'publishClick'

    initialize: (options) ->
      @assigned_peers = options.assigned_peers
      @display_peers()
      @prep_form_add_peer()


    display_peers: ->
      @assigned_peers.fetch
        success: =>
          container = $(@assigned_peer_list).empty()
          @assigned_peers.each (reviewee) =>
            if reviewee.get('reports_to')
              total_with_manager++
            new ReviewBatcherRevieweePeerView(container:container, model: reviewee, holder_view: @)


    prep_form_add_peer: =>
      form = $(@form_add_assigned_peer)
      input = form.find('input[name=guid_commas]')

      input.tokenInput "/people",
          theme: "namely",
          preventDuplicates:true,
          onResult: Utils.convertObjectsToTokens

      form.bind 'ajax:complete', =>
        input.tokenInput("clear")
        @display_peers()

    publishClick: (e) ->
      @$('#is_published').val(1)
