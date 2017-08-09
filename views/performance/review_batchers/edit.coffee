define ['jquery', 'underscore', 'backbone','utils',
        'views/performance/review_batchers/review_batcher_reviewee',
        'views/performance/review_creation_options'],($, _, Backbone, Utils,
        ReviewBatcherRevieweeView,
        ReviewCreationOptionsView) ->

  class ReviewBatcherEditView extends Backbone.View
    reviewee_list: '#current_reviewees'
    total_reviewees: '#total_reviewees'
    add_reviewee_forms: '#add_reviewee_forms'
    el: "#review_batcher_edit"

    events:
      'click #add_reviewee_options a': 'addRevieweeSelectorClick'
      'ajax:success .clear_all': 'displayReviewees'
      'change #review_batcher_settings_email_reminders': 'toggleReminders'

    initialize: (options) ->
      @reviewees = options.reviewees
      @displayReviewees()
      @prep_forms()
      @toggleReminders()
      new ReviewCreationOptionsView
      setTimeout ->
        @$("#add_reviewee_options a:first").trigger("click")
        100
      $('#review_batcher_settings_review_approver_tokens').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          onResult: Utils.convertObjectsToTokens})

    toggleReminders: ->
      if $('#review_batcher_settings_email_reminders').is(':checked')
        $('.reminders').show()
      else
        $('.reminders').hide()

    displayReviewees: ->
      total_with_manager = 0
      @reviewees.fetch
        success: =>
          container = $(@reviewee_list).empty()
          if @reviewees.length
            @reviewees.each (reviewee) =>
              if reviewee.get('reports_to')
                total_with_manager++
              new ReviewBatcherRevieweeView(container:container, model: reviewee, holder_view: @)
          else
            container.html("No Reviewees. Add more using the form above.")

          $(@total_reviewees).html(total_with_manager)

    prep_forms: =>
      forms = $(@add_reviewee_forms)
      input = forms.find('input[name=guid_commas]')
      input.tokenInput "/people",
          theme: "namely",
          preventDuplicates:true,
          onResult: Utils.convertObjectsToTokens
      forms.bind 'ajax:complete', =>
        input.tokenInput("clear")
        @displayReviewees()

    addRevieweeSelectorClick: (e) ->
      $target = $(e.target)
      target_slug = $target.attr('type')
      @$(@add_reviewee_forms+" form").hide()
      @$(@add_reviewee_forms+" #"+target_slug).show()
      @$('#add_reviewee_options a').removeClass("on")
      $target.addClass("on")
