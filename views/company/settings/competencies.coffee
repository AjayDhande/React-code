define ['underscore',
        'backbone',
        'views/competencies/category',
        'models/competencies/category'], (_,
        Backbone,
        CompetencyCategoryView,
        CompetencyCategoryModel) ->
  class CompetenciesView extends Backbone.View
    el: '#competency-categories'

    initialize: ->
      _.bindAll(@)
      _.each(@collection.models, (category) =>
        view = new CompetencyCategoryView(model: category).render()
        @$el.append(view.el))
      $('a.add-competency-category').click(@addCompetencyCategory)
      $('.loading').remove()

    addCompetencyCategory: (event) ->
      category = new CompetencyCategoryModel(text: '')
      view = new CompetencyCategoryView(model: category).render()
      @$el.append(view.el)
      view.$el.find('.toggle-competency-categories:last').trigger('click')
