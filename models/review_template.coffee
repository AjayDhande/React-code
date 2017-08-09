define ['backbone',
        'collections/review_template_question'], (Backbone,
        ReviewTemplateQuestionCollection) ->
  class ReviewTemplateModel extends Backbone.Model

    url: ->
      "/performance/review_templates/#{@id}"
    
    questionCollection: ->
      new ReviewTemplateQuestionCollection(@get('questions'))
