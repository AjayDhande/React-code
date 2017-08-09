define ['jquery', 'underscore', 'backbone',
        'views/performance/review_templates/question_choice',
        'templates/performance/templates/question'], ($, _, Backbone,
        ReviewTemplateQuestionChoiceView, template) ->

  class ReviewTemplateQuestionView extends Backbone.View
    template: template

    events:
      'click .ordered_header': 'questionClick'
      'click .add-choice': 'addChoice'
      'keyup .question_text': 'copyQuestionText'
      'keydown .question_text': 'copyQuestionText'
      'blur .question_text': 'copyQuestionText'
      'click .question_delete': 'deleteQuestion'
      'change .question_weight' : 'updateWeightPercentages'
      'change .rating_label' : 'updateRatingLabels'
      'change .rating-min' : 'updateRatingMin'
      'change .rating-max' : 'updateRatingMax'

    initialize: (options) ->
      @container = options.container
      @index = options.index
      @isNew = options.isNew
      @model = options.model
      @render()

    render: ->
      @question_id = @model.get('id')
      @$el = $(@template({
          text: @model.get('text'),
          index: @index,
          type:@model.get('type'),
          type_s:@model.get('type_s'),
          scope:@model.get('scope'),
          scope_s:@model.get('scope_s'),
          weight:@model.get('weight'),
          weight_percentage: @_weightPercentage(),
          weight_percentage_type: @_weightPercentageType(),
          question_id:@question_id,
          has_weight: @model.hasWeight(),
          options_rating_min: @model.get('options_rating_min'),
          options_rating_max: @model.get('options_rating_max'),
          options_use_decimal: @model.get('options_use_decimal'),
          options_use_comment: @model.get('options_use_comment'),
          options_use_na: @model.get('options_use_na'),
          options_use_labels: @model.get('options_use_labels'),
          options_only_use_labels: @model.get('options_only_use_labels'),
          options_rating_labels: @model.get("options_rating_labels")
        })).appendTo(@container)
      @setRatingLabelsHtml()

      if @model.get('type') == 'MultipleChoice'
        choices = @model.get('data') || ['']
        choiceContainer = @$('.choices-holder')
        for choice in choices
          new ReviewTemplateQuestionChoiceView(choice:choice, container:choiceContainer, question_id:@question_id)

      if(@isNew)
        @questionClick()
        @$('.question_text').focus()

      @$("input[name=options_use_labels\\[#{@question_id}\\]]").change(=>
        @toggleShowLabels()
      )

      @toggleShowLabels()
      @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").change(=>
        @toggleOnlyUseLabels()
      )
      @toggleOnlyUseLabels()

      @$("input[name=options_use_decimals\\[#{@question_id}\\]]").change(=>
        @toggleUseDecimals()
      )
      @toggleUseDecimals()


    _weightPercentage: ->
      Math.round((@model.get('weight') / @model.collection.totalQuestionWeight()) * 100).toString() + "%"

    _weightPercentageType: ->
      Math.round((@model.get('weight') / @model.collection.totalQuestionWeight(@model.get('scope'))) * 100).toString() + "%"

    updatePercentage: ->
      @$('.percentage_question_weight').text(@_weightPercentage())
      @$('.percentage_question_weight_type').text(@_weightPercentageType())

    updateWeightPercentages: (e) ->
      target = $(e.target)
      weight = parseInt(target.val()) || 0
      target.val(weight)
      @model.set('weight', weight)
      @model.collection.updateWeightPercentages()

    updateRatingMin: (e) ->
      target = $(e.target)
      min = parseInt(target.val()) || 0
      min = 0 if min < 0
      target.val(min)
      @model.set("options_rating_min", min)
      @updateRatingLabels()
      @setRatingLabelsHtml()
    updateRatingMax: (e) ->
      target = $(e.target)
      max = parseInt(target.val()) || 1
      max = 1 if max < 1
      target.val(max)
      @model.set("options_rating_max", max)
      @updateRatingLabels()
      @setRatingLabelsHtml()
    updateRatingLabels: ->
      labels_hash = {}
      @$(".rating_label").each( ->
        labels_hash[$(this).data("rating-value")] = $(this).val()

      )
      @model.set("options_rating_labels", labels_hash)
    setRatingLabelsHtml: ->
      if @$("[name='options_use_labels\\[#{@question_id}\\]']").first().is(":checked")
        @$(".options_rating_labels_container").html("")
        options_rating_labels = @model.get("options_rating_labels")
        for value in [@model.get("options_rating_min")..@model.get("options_rating_max")]
          rating_label = $("<div>").addClass("rating-label")
          $("<label>#{value}</label>")
            .addClass("aligned")
            .appendTo(rating_label)
          $("<input>", {
            class: "rating_label"
            name: "options_rating_labels[#{@model.get('id')}][#{value}]"
            data: {
              "rating-value": value
            }
          }).val(options_rating_labels[parseInt(value)])
            .addClass("aligned")
            .appendTo(rating_label)
          rating_label.appendTo @$(".options_rating_labels_container")
    questionClick: ->
      @$el.toggleClass('open')
      @$('.question_edit_form_wrapper').slideToggle()

    addChoice: (e) ->
      choiceContainer = @$('.choices-holder')
      new ReviewTemplateQuestionChoiceView(choice:'', container:choiceContainer, question_id:@question_id)

    copyQuestionText: (e) ->
      $target = $(e.target)
      @$('.header_question_text').html($target.val())

    deleteQuestion: (e) ->
      @model.collection.remove @model
      @$el.remove()
      Namely.reviewTemplateForm.deleteQuestion(@question_id, @isNew)
    toggleShowLabels: ->
      @setRatingLabelsHtml()
      if @$("input[name=options_use_labels\\[#{@question_id}\\]]").is(":checked")
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").attr("disabled", false)
        @$(".options_rating_labels_container").show()
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").show()

        @$("label[for=only-use-labels-checkbox-#{@question_id}]").show()
      else
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").prop('checked', false).attr("disabled", true)
        @$(".options_rating_labels_container").hide()
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").hide()
        @$("label[for=only-use-labels-checkbox-#{@question_id}]").hide()


    toggleOnlyUseLabels: ->
      if @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").is(":checked")
        @$("label[for=decimal-checkbox-#{@question_id}]").html("Use Decimal (This option can't be used while only displaying labels)").css("color", "#B2B2B2")

        @$("input[name=options_use_decimals\\[#{@question_id}\\]]").prop('checked', false)
        @$("input[name=options_use_decimals\\[#{@question_id}\\]]").attr('disabled', true)
      else
        @$("input[name=options_use_decimals\\[#{@question_id}\\]]").attr('disabled', false)
        @$("label[for=decimal-checkbox-#{@question_id}]").html("Use Decimal").css("color", "black")

    toggleUseDecimals: ->
      if @$("input[name=options_use_decimals\\[#{@question_id}\\]]").is(":checked")
        @$("label[for=only-use-labels-checkbox-#{@question_id}]").html("Only Use Labels for Options (This option can't be used while displaying decimals)").css("color", "#B2B2B2")
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").attr("checked", false)
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").attr("disabled", true)
      else
        @$("input[name=options_only_use_labels\\[#{@question_id}\\]]").attr("disabled", false)
        @$("label[for=only-use-labels-checkbox-#{@question_id}]").html("Only Use Labels for Options").css("color", "black")


