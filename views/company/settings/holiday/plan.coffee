define ['underscore',
        'backbone',
        'views/company/settings/holiday/holiday',
        'views/company/settings/holiday/plan_delete',
        'views/scopes/list',
        'templates/holiday/plan',
        'templates/components/errors'], (_,
        Backbone,
        HolidayView,
        HolidayPlanDeleteView,
        ScopeListView,
        template,
        errorTemplate) ->
  class HolidayPlanView extends Backbone.View
    className: 'holiday-plan'
    events:
      'change input.holiday-plan-name': 'updateName'
      'change input.plan-company-wide': 'updateCompanyWide'
      'click .save-plan': 'savePlan'
      'click .add-holiday': 'addHoliday'
      'click .toggle-holiday-plan': 'toggle'
      'click .edit-plan': 'enableEditMode'

    updateName: (e) ->
      $target = $(e.currentTarget)
      name = $target.val()
      @model.set('name', name)

    updateScopeView: ->
      if @model.get('company_wide')
        @scopeView.disable()
      else
        @scopeView.enable()

    updateCompanyWide: (e) ->
      $target = $(e.currentTarget)
      checked = $target.is(':checked')
      @model.set('company_wide', checked)
      @updateScopeView()

    enableViewMode: ->
      @$el.removeClass("edit")
      @$el.addClass("view")
      @$("input").attr("disabled", "disabled")
      @$('.toggle-container').removeClass('disabled')
      input = @$('.holiday-plan-name')
      input.attr('size', input.val().length + 2)
      @$('.scope-label').text('Plan Coverage:')
      @$('.scope-label').show()
      if @model.get('company_wide')
        @$('.scope-description').text('company-wide')
        @$('.scope-description').show()
        @$('.scopes .scope').hide()
      else
        if @model.get('profile_scopes').length == 0
          @$('.scope-hint').text('no filters have been added')
          @$('.scope-hint').show()
      if @model.get('holidays').length == 0
        @$('tr.hint').show()
      @viewMode = true

    enableEditMode: ->
      @$el.removeClass("view")
      @$el.addClass("edit")
      @$("input").removeAttr("disabled")
      @$('.toggle-container').addClass('disabled')
      input = @$('.holiday-plan-name')
      input.removeAttr('size')
      @$('.scope-label, .scope-description, .scope-hint, tr.hint').hide()
      @viewMode = false

    render: ->
      @$el.html(template(model: @model, id: Date.now()))
      @resetHolidays()
      @scopeView = new ScopeListView(
        el: @$('.scopes'),
        parent: @model,
        collection: @model.get('profile_scopes'),
        fields: [{value: 'office_location', name: 'Office'}]).render()
      @updateScopeView()
      @model.el = @$el
      new HolidayPlanDeleteView(model: @model, el: @$('.delete-plan-tool'))
      @updateHolidayCounter()
      @enableViewMode()
      @

    savePlan: (e) ->
      e.preventDefault()
      @$('.save-plan').attr('disabled', 'disabled').text('Saving...')
      if request = @model.save(wait: true)
        @hideErrors()
        request.always(=> @saved())
      else
        @$('.save-plan').removeAttr('disabled').text('Save Plan')
        errors = @model.validationError
        @showErrors(errors)

    saved: ->
      setTimeout(( =>
        @$('.save-plan').removeAttr('disabled').text('Save Plan')
        @scopeView.collection = @model.get('profile_scopes')
        @scopeView.render()
        @updateScopeView()
        @enableViewMode()
        @resetHolidays()), 1000)

    resetHolidays: ->
      @$('.holidays .holiday').remove()
      @model.get('holidays').each (holiday) => @insertHoliday(holiday)

    insertHoliday: (holiday) ->
      @model.get('holidays').add(holiday)
      view = new HolidayView(model: holiday)
      @$('.holidays > tbody').append(view.render().el)
      @$('.holidays .header').show()

    addHoliday: (e) ->
      holidays = @model.get('holidays')
      holiday = new holidays.model()
      @insertHoliday(holiday)

    hideErrors: ->
      @$('.errors').hide()
      @$('.field-error').removeClass('field-error')

    renderErrors: (errors) ->
      @$('.errors').html(errorTemplate(errors: errors))
      @$('.errors').show()
      _.each errors, (messages, field) =>
        @$("[name='plan[#{field}]']").addClass('field-error')

    showErrors: (errors) ->
      @hideErrors()
      @renderErrors(errors)

    enableCompanyWide: ->
      @$('input.plan-company-wide').attr('checked', 'checked')

    toggle: (e) ->
      if @viewMode
        target = $(e.target)
        toggle = target.parent()
        plan = toggle.parent().find('.plan')
        plan.toggle()

        if plan.is(':hidden')
          target.attr('readonly', 'readonly')
          toggle.removeClass('close')
          toggle.addClass('close')
          @updateHolidayCounter()
        else
          target.removeAttr('readonly')
          toggle.removeClass('close')

    updateHolidayCounter: ->
      count = @$('.holidays .holiday').length
      if count > 1
        @$(".holiday-counter").html("#{count} holidays")
      else if count == 1
        @$(".holiday-counter").html("1 holiday")
      else
        @$(".holiday-counter").html("")
