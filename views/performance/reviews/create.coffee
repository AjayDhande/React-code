define ['jquery', 'underscore', 'backbone',
        'utils', 'overlay',
        'views/performance/review_group_options',
        'jquery.tokeninput',
        'nested_form'], ($, _, Backbone, Utils, OVLY,
        ReviewGroupOptionsView) ->
  class ReviewCreateView extends Backbone.View
    el: '#content'

    events:
      'click #reviewee_template_preview': 'revieweeTemplatePreview'
      'click #reviewer_template_preview': 'reviewerTemplatePreview'
      'change select.template_select': 'showPreviewButton'
      'change #review_summarized_ratings': 'changeSummarizedRatings'
      'change #review_summarize_by_question_types': 'changeSummarizeByQuestionTypes'
      'change #review_email_reminders': 'toggleReminders'

    @selected_reviewee_template = -1
    @selected_reviewer_template = -1

    initialize: ->
      $('#review_peer_reviewer_ids').tokenInput "/people",
        theme: "namely",
        preventDuplicates: true,
        onResult: Utils.convertObjectsToTokens

      $('#review_reviewee').tokenInput "/people",
        theme: "namely",
        preventDuplicates: true,
        onResult: Utils.convertObjectsToTokens
        tokenLimit: 1

      $('#review_review_managers_to_tokens').tokenInput "/people",
        theme: "namely",
        preventDuplicates: true,
        onResult: Utils.convertObjectsToTokens
        tokenLimit: 1

      Utils.setupDatePicker()

      new ReviewGroupOptionsView

    toggleReminders: (e) ->
      if $('#review_email_reminders').is(':checked')
        $(@el).find('.reminders').show()
      else
        $(@el).find('.reminders').hide()

    showRevieweeSelect: ->
      @revieweeSelect = new Namely.Views.RevieweeSelect
        el: @$('#reviewee_id_wrap')
        model: @model
      @revieweeSelect.render()

    revieweeTemplatePreview: ->
      OVLY.showURL('/performance/review_templates/'+@selected_reviewee_template+'/preview', 675, 400);

    reviewerTemplatePreview: ->
      OVLY.showURL('/performance/review_templates/'+@selected_reviewer_template+'/preview', 675, 400);

    changeSummarizedRatings: (e) ->
      $('#summarized_ratings_toggle').toggle()

    changeSummarizeByQuestionTypes: (e) ->
      $('#summarize_by_question_types_toggle').toggle()

    showPreviewButton: (e) ->
      $select = $(e.currentTarget)
      $button = $select.parents('.template_holder').find('.preview_button')
      id = $select.val()
      if (id)
        if $button.attr('id') == 'reviewee_template_preview'
          @selected_reviewee_template = id
        else
          @selected_reviewer_template = id
        $button.fadeIn()
      else
        $button.fadeOut()

