define ['underscore', 'backbone',
    'views/company/settings/time_off/modifier',
    'views/company/settings/time_off/reset',
    'templates/time_off/plan',
    'templates/time_off/plan_form',
    'templates/components/errors'], (_, Backbone,
    ModifierView,
    ResetModalView,
    template,
    formTemplate,
    errorTemplate) ->
  class PlanView extends Backbone.View
    events:
      'change .plan-base input': 'change'
      'change .plan-base select': 'change'
      'blur .plan-base [contenteditable]': 'change'
      'keyup .plan-base [contenteditable]': 'change'
      'click .add-modifier': 'addModifier'
      'click .toggle-modifiers': 'toggleModifiers'
      'click .reset-plan': 'resetPlan'
      'click .delete-plan': 'confirmDeletePlan'
      'click .content-delete .confirm-delete-plan': 'deletePlan'
      'click .content-delete .cancel': 'cancelDeletePlan'

    className: 'plan'
    baseContainer: null
    modifiersContainer: null
    modifierViews: {}
    dirty: false

    initialize: ->
      @model.on 'add:modifiers', @insertModifier, @
      @model.on 'change:unlimited', @toggleBaseDaysOff, @
      @model.on 'change:refresh_on_anniversary', @toggleRefreshDate, @
      @model.on 'change:carries_over', @toggleCarryover, @

    render: ->
      @$el.html(template(model: @model))
      @modifiersContainer = @$('.modifiers .content')
      @model.get('modifiers').each (modifier) =>
        @insertModifier(modifier)
      @toggleBaseDaysOff()
      @toggleRefreshDate()
      @toggleCarryover()
      @updateModifierCount()
      @

    toggleModifiers: ->
      container = @$el.find('.toggle-container')
      container.toggleClass('close')
      container.parent().toggleClass('close')

    open: ->
      container = @$el.find('.toggle-container')
      container.removeClass('close')
      container.parent().removeClass('close')

    insertModifier: (modifier) ->
      view = new ModifierView(model: modifier)
      view.on 'delete', @updateModifierCount, @
      @modifiersContainer.prepend(view.render().el)

    change: (e) ->
      $el = $(e.currentTarget)
      name = $el.attr('name')
      matches = name.match(/plan\[(\w+)\]/i)
      val = if $el.attr('contenteditable')
              $el.text()
            else if $el.is('input:checkbox')
              $el.prop('checked')
            else
              $el.val()
      @model.set(matches[1], val)

    addModifier: (e) ->
      e.preventDefault()
      @model.addModifier()
      @open()
      @updateModifierCount()

    confirmDeletePlan: (e) ->
      e.preventDefault()
      @$(".plan-base").addClass("hidden")
      @$(".plan-form > .content-delete").removeClass("hidden")

    cancelDeletePlan: (e) ->
      e.preventDefault()
      @hideErrors()
      @$(".plan-base").removeClass("hidden")
      @$(".plan-form > .content-delete").addClass("hidden")

    resetPlan: (e) ->
      e.preventDefault()
      @modal = new ResetModalView({parentView: @, model: @model})

    deletePlan: (e) ->
      e.preventDefault()
      @hideErrors()
      if @model.isNew()
        @$el.remove()
        @model.destroy()
      else
        @model.destroy(wait: true).then (response) =>
          @remove()
        , (response) =>
            @showErrors JSON.parse(response.responseText)

    save: ->
      @hideErrors()
      @model.save().fail (response) =>
        @showErrors JSON.parse(response.responseText)

    hideErrors: ->
      @$('.errors').hide()
      @$('.field-error').removeClass('field-error')

    showErrors: (errors) ->
      @renderErrors(errors)
      @$('.errors').show()
      @$('.field-error').removeClass('field-error')
      _.each errors, (messages, field) ->
        @$("[name='plan[#{field}]'").addClass('field-error')

    renderErrors: (errors) ->
      @$('.errors').html(errorTemplate(errors: errors))

    updateModifierCount: ->
      count = @model.get('modifiers').reject((modifier) -> modifier.get('_destroy')).length
      @$('.modifier-count').html count

      if count == 0
        @$('.modifiers').hide()
      else
        @$('.modifiers').show()
        @$('.last-child').removeClass('last-child')
        @$el.find('.modifier-container + .modifier-container:not(".hidden-child")').last().addClass('last-child')
        if count == 1
          @$('.modifier-count-label').html ' Qualifier'
          @$('.modifier-container').addClass('last-child')
        else
          @$('.modifier-count-label').html ' Qualifiers'

    toggleBaseDaysOff: ->
      if @model.get('unlimited')
        @$('input.base-days-off').prop('disabled', true)
      else
        @$('input.base-days-off').prop('disabled', false)

    toggleCarryover: ->
      if @model.get('carries_over')
        @$('.carryover input').prop('disabled', false)
        @$('.carryover-expiration input').prop('disabled', false)
        @$('.carryover-expiration select').prop('disabled', false)
      else
        @$('.carryover input').prop('disabled', true)
        @$('.carryover-expiration input').prop('disabled', true)
        @$('.carryover-expiration select').prop('disabled', true)

    toggleRefreshDate: ->
      if @model.get('refresh_on_anniversary')
        @$('.refresh-date input').prop('disabled', true)
        @$('.refresh-date select').prop('disabled', true)
      else
        @$('.refresh-date input').prop('disabled', false)
        @$('.refresh-date select').prop('disabled', false)
