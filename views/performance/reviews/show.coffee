define ['jquery', 'underscore', 'backbone', 'utils', 'graph',
        'views/performance/review_group_options'], ($, _, Backbone, Utils, GRAPH,
        ReviewGroupOptionsView) ->
  # Uses a timer for the scroll event to reduce overhead for slower machines.
  # If the fixed sidebar is responding too slowly, simply change speed.
  $.fn.scrolled = (fn) ->
    speed = 10
    tag = "scrollTimer"
    this.scroll ->
      self = $(this)
      timer = self.data(tag)
      if (timer)
        clearTimeout(timer)
      tf = ->
        self.data(tag, null)
        fn()
      timer = setTimeout(tf, speed)
      self.data(tag, timer)

  class ReviewShowView extends Backbone.View
    el: '#content'
    events:
      'click li#reviewer_tab' : 'showReviewerQuestions'
      'click li#reviewee_tab' : 'showRevieweeQuestions'
      'click li#performance_tab.manage' : 'showPerformanceForm'
      'click .ordered_header' : 'selectQuestion'
      'click .expand_all_answers' : 'expandAll'
      'click .close_all_answers' : 'closeAll'
      'click .manage_reviewer .cancel_reject' : 'toggleReject'
      'click .manage_reviewer a.unreject' : 'toggleUnreject'
      'click .manage_reviewer .cancel_unreject' : 'toggleUnreject'
      'click .manage_reviewer a.reject' : 'toggleReject'
      'click .manage_reviewer .cancel_share' : 'toggleShare'
      'click .manage_reviewer a.share' : 'toggleShare'
      'click .manage_reviewer .cancel_delete' : 'toggleDelete'
      'click .manage_reviewer a.delete' : 'toggleDelete'
      'click .manage-review .cancel-share-all' : 'toggleShareAll'
      'click .manage-review a.share-all' : 'toggleShareAll'
      'change #review_summarized_ratings': 'changeSummarizedRatings'
      'change #review_summarize_by_question_types': 'changeSummarizeByQuestionTypes'

    fixSidebar = ->
      y = $(window).scrollTop()
      bottom = $(document).height() - $('#review_sidebar').outerHeight() - parseInt($('#content').css('padding-bottom'), 10) - 50
      if y > 317 && y <= bottom
        $('#review_sidebar').css
          'position': 'fixed'
          'top': '25px'
          'bottom': 'auto'
          'right': '50%'
          'margin-right': '-467px'
      else if y <= 317
        $('#review_sidebar').css
          'position': 'absolute'
          'top': '242px'
          'bottom': 'auto'
          'right': '25px'
          'margin-right': '0px'
      else if y > bottom
        $('#review_sidebar').addClass('bottom').css
          'position': 'absolute'
          'top': 'auto'
          'bottom': '15px'
          'right': '25px'
          'margin-right': '0px'

    bumpSidebar = ->
      $("html, body").animate
        scrollTop: $(document).scrollTop() - 70 + 'px'
      $('#review_sidebar').removeClass('bottom').css
        'position': 'absolute'
        'top': '242px'
        'bottom': 'auto'
        'right': '25px'
        'margin-right': '0px'

    initialize: (options)->
      if $("#review_summarized_ratings").is(":checked")
        $('#summarized_ratings_toggle').show();

      if $("#review_summarize_by_question_types").is(":checked")
        $('#summarize_by_question_types_toggle').show();

      $('#review_show').css('min-height', $('#review_sidebar').outerHeight()+20)
      $('.loading').remove()

      if $('#reviewer_questions').length
        @showReviewerQuestions()
      else if $('#reviewee_questions').length
        @showRevieweeQuestions()
      else
        @showPerformanceForm()
      $('#review_tabs li:first').trigger('click')
      if $(window).height() > $('#review_sidebar').outerHeight()
        fixSidebar()
        $(window).scrolled -> fixSidebar()
      if window["gdata"] and window["gdata"]["graphs"]
        GRAPH.init()
      $('#review_review_managers_to_tokens').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          onResult: Utils.convertObjectsToTokens})
      $('#review_review_excludes_to_tokens').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          onResult: Utils.convertObjectsToTokens})
      $('#review_review_additional_reviewers').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          onResult: Utils.convertObjectsToTokens})
      $('#review_review_additional_approvers').tokenInput("/people", {
          theme: "namely"
          preventDuplicates: true
          onResult: Utils.convertObjectsToTokens})
      $('input[type=range]').each (index, element) =>
        $input = $(element)
        question_id = $input.data("question")
        question = @model.find_question(question_id)
        if(question)
          $slider = $('<div id="' + $input.attr('id') + '" class="' + $input.attr('class') + '"></div>')
          $display = $input.siblings('.display').find('span')
          if question["options"]["use_labels"]
            if question["options"]["only_use_labels"]
              $display.html(question["options"]["rating_labels"][Math.round($input.val())])
            else
              $display.html("#{$input.val()}: #{question['options']['rating_labels'][Math.round($input.val())]}")
          else
            $display.html($input.val())
          $input.after($slider).hide()
          $slider.slider
            range: 'min'
            min: Number($input.attr('min'))
            max: Number($input.attr('max'))
            step: Number($input.attr('step'))
            value: $input.attr('value')
            change: (e, ui) ->
              $input.attr('value', ui.value)
            slide: (e,ui) =>
              if question["options"]["use_labels"]
                if question["options"]["only_use_labels"]
                  $display.html(question['options']['rating_labels'][Math.round(ui.value)])
                else
                  $display.html("#{ui.value}: #{question['options']['rating_labels'][Math.round(ui.value)]}")
              else
                $display.html(ui.value)
          na = $input.parent().find('.na-checkbox')
          $slider.slider('disable') if na.prop('checked')

      new ReviewGroupOptionsView

    changeSummarizedRatings: (e) ->
      $('#summarized_ratings_toggle').toggle()

    changeSummarizeByQuestionTypes: (e) ->
      $('#summarize_by_question_types_toggle').toggle()

    closeAll: ->
      $('.question').removeClass('open').find('.answers').slideUp()

    expandAll: ->
      $('.question').addClass('open').find('.answers').slideDown()
      if $('#review_sidebar').hasClass('bottom')
        bumpSidebar()

    selectQuestion: (e) ->
      $target = $(e.target).parents('.question')
      $target.toggleClass('open')
      $target.find('.answers').slideToggle()
      if $('#review_sidebar').hasClass('bottom')
        bumpSidebar()

    showReviewerQuestions: (e) ->
      $('#reviewee_questions, #performance_form').fadeOut()
      $('#reviewee_tab').removeClass('active')
      $('#reviewer_questions').fadeIn()
      $('#reviewer_tab').addClass('active')
      if $(window).scrollTop() > 320
        $(window).scrollTop(321)

    showRevieweeQuestions: (e) ->
      $('#reviewer_questions, #performance_form').fadeOut()
      $('#reviewer_tab').removeClass('active')
      $('#reviewee_questions').fadeIn()
      $('#reviewee_tab').addClass('active')
      if $(window).scrollTop() > 320
        $(window).scrollTop(321)

    showPerformanceForm: (e) ->
      Utils.setupDatePicker()
      $('#reviewer_questions, #reviewee_questions').fadeOut()
      $('#reviewer_tab, #reviewee_tab').removeClass('active')
      $('#performance_form').fadeIn()
      if $(window).scrollTop() > 320
        $(window).scrollTop(321)

    toggleShare: (e) ->
      e.preventDefault()
      $target = $(e.target).parents('.manage_reviewer')
      $target.find('.share_area').toggle()

    toggleShareAll: (e) ->
      e.preventDefault()
      $target = $(e.target).parents('.manage-review')
      $target.find('.share-all-area').toggle()

    toggleReject: (e) ->
      $target = $(e.target).parents('.manage_reviewer')
      $target.find('.reject_area').toggle()

    toggleUnreject: (e) ->
      $target = $(e.target).parents('.manage_reviewer')
      $target.find('.unreject_area').toggle()

    toggleDelete: (e) ->
      $target = $(e.target).parents('.manage_reviewer')
      $target.find('.delete_area').toggle()

