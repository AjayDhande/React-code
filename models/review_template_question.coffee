define ['backbone'], (Backbone) ->
  class ReviewTemplateQuestionModel extends Backbone.Model
    #data, id, text, type, type_s, scope, scope_s

    defaults:
      options_rating_labels: {}
    updateWeightPercentage: ->
      @view.updatePercentage()

    hasWeight: ->
      type = @get('type')
      (type == "Rating")
