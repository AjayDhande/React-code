define ['jquery', 'underscore', 'backbone',
        'models/review_template_question',
        'views/performance/review_templates/question',
        'templates/performance/templates/deleted_question'], ($, _, Backbone,
        ReviewTemplateQuestionModel,
        ReviewTemplateQuestionView, template) ->

  class ReviewTemplateFormView extends Backbone.View
    el: '#template_edit'
    question_holder: '#question_holder'
    newId: 0

    events:
      'click .add-question': 'addQuestion'
      'click .publish': 'publishClick'

    deleted_question_template: template

    initialize: ->
      @$container = @$(@question_holder)
      @model.on("change", @render, @)

    render:  ->
      @collection = @model.questionCollection()
      @collection.each((question, index) =>
        view = new ReviewTemplateQuestionView(container: @$container, model: question, index: index, isNew:false)
        question.view = view
      )

      @$container.sortable({
        axis:'y',
        opacity:.6,
        forceHelperSize:true,
        helper: 'clone',
        handle: ".ordered_header"
        stop: (e) =>
          @reorderQuestions()
      });

    deleteQuestion: (id,isNew) ->
      if(!isNew)
        @$container.append(@deleted_question_template(id:id))
      @reorderQuestions()
      @collection.updateWeightPercentages()

    reorderQuestions: ->
      @$('.question').each (index, element) ->
        $(element).find('.ordered_header_number').html(index+1)

    addQuestion: (e) ->
      type = @$('#question-types').val()
      type_s = @$('#question-types').find(":selected").text()
      scope = @$('#question-scopes').val()
      scope_s = @$('#question-scopes').find(":selected").text()

      last_question = @collection.last()
      options_rating_min = $('.question_rating_min').last().val() || 1
      options_rating_max = $('.question_rating_max').last().val() || 5
      if $('.question_use_labels').last().prop('checked')
        options_use_labels = 'on'
        if $('.question_only_use_labels').last().prop('checked')
          options_only_use_labels = 'on'
        else
          options_only_use_labels = null
        options_rating_labels = last_question.get("options_rating_labels")
      else
        options_use_labels = null
        options_only_use_labels = null
        options_rating_labels = {}


      options_use_decimal = if $('.question_use_decimal').last().prop('checked') then 'on' else null
      options_use_comment = if $('.question_use_comment').last().prop('checked') then 'on' else null
      options_use_na = if $('.question_use_na').last().prop('checked') then 'on' else null
      weight = $('.question_weight').last().val() || 1

      id = "new_"+(@newId++)
      question = new ReviewTemplateQuestionModel({
        type:type,
        id:id,
        type_s:type_s,
        scope:scope,
        scope_s:scope_s,
        weight:weight,
        options_rating_min:options_rating_min,
        options_rating_max:options_rating_max,
        options_use_labels: options_use_labels,
        options_only_use_labels: options_only_use_labels,
        options_rating_labels: options_rating_labels
        options_use_decimal:options_use_decimal,
        options_use_comment:options_use_comment,
        options_use_na:options_use_na})
      index = @$('.question').length
      @collection.add question
      view = new ReviewTemplateQuestionView(container:@$container, model: question, index:index, isNew:true)
      question.view = view
      @collection.updateWeightPercentages()

    publishClick: (e) ->
      @$('#review_template_is_published').val(1)
