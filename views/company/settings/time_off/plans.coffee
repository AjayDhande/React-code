define ['underscore', 'backbone',
    'views/company/settings/time_off/plan',
    'views/company/settings/time_off/type',
    'templates/time_off/plans'], (_, Backbone,
    PlanView, TypeView, template) ->
  class PlansView extends Backbone.View
    events:
      'click .save': 'saveAll'
      'click .type-new': 'newType'

    typeViews: []
    planViews: []

    initialize: ->
      @collection.on('reset', @reset, @)

    reset: ->
      @$el.html(template())

      @collection.types.each (type) =>
        @addType(type)

      @renderTypes()

      @collection.each (plan) =>
        @addPlan(plan)

      @renderPlans()

    addType: (type) ->
      typeView = new TypeView(model: type, plans: @collection)
      typeView.on 'newPlan', @newPlan, @
      @typeViews.push(typeView)
      (@$types ||= @$('.types')).append(typeView.el)
      typeView

    newPlan: (type) ->
      plan = new @collection.model(type_id: type.id)
      @collection.add([plan])
      @addPlan(plan).render()

    addPlan: (plan) ->
      typeView = _.find(@typeViews, (view) -> view.model.id == plan.get('type_id'))
      if typeView
        planView = typeView.addPlan(plan)
        @planViews.push(planView)
      planView

    newType: (e) ->
      e.preventDefault()
      type = @collection.types.create({ title: 'New Type'}, {
          wait: true,
          success: (type) =>
            @addType(type).render().open()
            @newPlan(type)
        })

    renderTypes: ->
      for typeView in @typeViews
        typeView.render()

    renderPlans: ->
      for planView in @planViews
        planView.render()

    orderPlans: ->
      # TODO: Order plan dom objects using attribute.

    saveAll: ->
      @collection.types.each (type) =>
        if type.hasChanged()
          type.save()

      @saving = 0
      for planView in @planViews
        if request = planView.save()
          @saving++
          request.always(=> @saved())

      if @saving > 0
        @$('.save').attr('disabled', 'disabled').text('Saving...')

    saved: ->
      @saving--
      if @saving == 0
        @$('.save').removeAttr('disabled').text('Save All')
