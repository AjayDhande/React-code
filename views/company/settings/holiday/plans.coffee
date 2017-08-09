define ['underscore',
        'backbone',
        'utils',
        'views/company/settings/holiday/plan',
        'templates/holiday/plans'], (_, Backbone, Utils,
        HolidayPlanView,
        template) ->
  class HolidayPlansView extends Backbone.View
    events:
      'click .add-plan': 'newPlan'

    planViews: []

    initialize: ->
      @collection.on('reset', @reset, @)
      Utils.setupDatePicker(@$el)

    reset: ->
      @$el.html(template())
      @collection.each (plan) =>
        @addPlan(plan).render()

    addPlan: (plan) ->
      view = new HolidayPlanView(model: plan)
      @planViews.push(view)
      @$('.plans').append(view.el)
      view

    newPlan: ->
      plan = new @collection.model()
      @collection.add(plan)
      view = @addPlan(plan).render()
      view.addHoliday()
      view.$el.find('.toggle-holiday-plan').trigger('click')
      view.enableEditMode()
