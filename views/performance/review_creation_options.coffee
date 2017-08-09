define ['jquery', 'underscore', 'backbone',
        'utils', 'overlay', 'views/performance/review_group_options'
        'jquery.tokeninput',], ($, _, Backbone, Utils, OVLY,
        ReviewGroupOptionsView) ->
  class ReviewCreationOptionsView extends Backbone.View
    el: '#review_creation_options'
    type_select: '#review_type_select'
    type_displays: '.dynamic_type_display'

    events:
      'click #reviewee_template_preview': 'revieweeTemplatePreview'
      'click #reviewer_template_preview': 'reviewerTemplatePreview'
      'change select.template_select': 'showPreviewButton'
      'change #review_batcher_settings_summarized_ratings': 'changeSummarizedRatings'
      'change #review_batcher_settings_summarize_by_question_types': 'changeSummarizeByQuestionTypes'
      'change #review_batcher_settings_override_administrator_to_manager_direct_report': 'toggleReportsToReportsTo'
      'change #review_type_select': 'toggleOnReviewType'
      'change #review_batcher_settings_finalize_with_manager_template': 'toggleFinalizationManagerTemplateHolder'
      'change #review_batcher_settings_finalize_with_external_approval': 'toggleReviewApproversHolder'
      'click .publish': 'publishClick'

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

      $('#review_batcher_review_administrators_to_tokens').tokenInput "/people",
        theme: "namely",
        preventDuplicates: true,
        onResult: Utils.convertObjectsToTokens

      $("input.date").datepicker
        dateFormat: "yy-mm-dd"
        changeMonth: true
        changeYear: true

      if $("#review_batcher_settings_summarized_ratings").is(":checked")
        $('#summarized_ratings_toggle').show();

      if $("#review_batcher_settings_summarize_by_question_types").is(":checked")
        $('#summarize_by_question_types_toggle').show();

      if $("#review_batcher_settings_override_administrator_to_manager_direct_report").is(":checked")
        $('#current_reviewees').addClass("show_reports_to_reports_to");

      if $("#review_batcher_settings_finalize_with_manager_template").is(":checked")
        $('#finalization_manager_template_holder').show();

      if $("#review_batcher_settings_finalize_with_external_approval").is(":checked")
        $('#review_approvers_holder').show();

      @toggleOnReviewType()

      new ReviewGroupOptionsView

      $(document).on "nested:fieldAdded", (event) ->
        field = event.field
        dateField = field.find(".date")
        dateField.datepicker()
        return

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

    toggleReportsToReportsTo: (e) ->
      $('#current_reviewees').toggleClass("show_reports_to_reports_to");

    toggleFinalizationManagerTemplateHolder: (e) ->
      $('#finalization_manager_template_holder').toggle()

    toggleReviewApproversHolder: (e) ->
      $('#review_approvers_holder').toggle()

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

    toggleOnReviewType: =>
      type = $(@type_select).find('option:selected').attr('sym')
      $(@type_displays).hide()
      if(type)
        $(@type_displays+'.type_'+type).show()

    publishClick: (e) ->
      @$('#review_batcher_is_published').val(1)

