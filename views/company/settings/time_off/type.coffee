define ['underscore', 'backbone',
    'views/company/settings/time_off/plan',
    'templates/time_off/type'], (_, Backbone,
    PlanView,
    template) ->
  class TypeView extends Backbone.View
    className: 'type close'
    plansContainer: null
    planViews: []

    initialize: ->
      @plans = @options.plans

    events:
      'click .add-plan': 'newPlan'
      'click .toggle-type': 'toggleType'
      'change .type-title': 'changeTitle'
      'click .delete-type': 'confirmDeleteType'
      'click .cancel': 'cancelDelete'
      'click .confirm-delete-type': 'deleteType'

    newPlan: (e)->
      e.preventDefault()
      @trigger 'newPlan', @model

    addPlan: (plan) ->
      planView = new PlanView(model: plan)
      @planViews.push(planView)
      @plansContainer.append(planView.el)
      planView

    render: ->
      @$el.html template(model: @model)
      @plansContainer = @$('.plans')
      @

    toggleType: ->
      @$('.toggle-container:first').toggleClass('close')
      @$el.toggleClass('close')

    close: ->
      @$('.toggle-container').addClass('close')
      @$el.addClass('close')

    open: ->
      @$('.toggle-container').removeClass('close')
      @$el.removeClass('close')

    changeTitle: (e) ->
      @model.set('title', $(e.currentTarget).val())

    confirmDeleteType: (e) ->
      @$('.content').addClass('hidden')
      @$('.content-delete').removeClass('hidden')

    cancelDelete: (e) ->
      e.preventDefault()
      @$('.content').removeClass('hidden')
      @$('.content-delete').addClass('hidden')

    deleteType: (e) ->
      e.preventDefault()
      @model.destroy()
      @remove()




