define ['backbone',
        'models/review_template',
        'views/performance/review_templates/index',
        'views/performance/review_templates/form'], (Backbone,
        ReviewTemplateModel,
        ReviewTemplateIndexView,
        ReviewTemplateFormView) ->
  class ReviewTemplatesRouter extends Backbone.SubRoute
    routes:
      '' : 'index'
      ':id/edit' : 'reviewTemplateForm'

    index: ->
      new ReviewTemplateIndexView()

    reviewTemplateForm: (id) ->
      model = new ReviewTemplateModel(id: id)
      Namely.reviewTemplateForm = new ReviewTemplateFormView
        model: model
      model.fetch()

