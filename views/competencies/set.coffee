define ['backbone',
        'templates/competencies/set',
        'templates/components/errors',
        'models/competency',
        'views/scopes/list',
        'views/competencies/competency'], (Backbone,
        template,
        errorTemplate,
        CompetencyModel,
        ScopeListView,
        CompetencyView) ->
  class CompetencySetView extends Backbone.View
    className: 'competency-set'

    events:
      'change input.company-wide': 'updateCompanyWide'
      'change input.competency-set-text': 'update'
      'click a.save-competency-set': 'save'
      'click a.remove-competency-set': 'remove'
      'click a.add-competency': 'addCompetency'

    initialize: ->
      _.bindAll(@)

    render: ->
      @$el.html(template(set: @model, id: Date.now()))
      @model.get('competencies').each (competency) =>
        view = new CompetencyView(set: @, model: competency).render()
        @$('.competencies').append(view.el)
      @scopeView = new ScopeListView(
        el: @$('.scopes'),
        parent: @model,
        collection: @model.get('profile_scopes')).render()
      @updateScopeView()
      @updateCompanyWide()
      @

    update: (e) ->
      el = $(e.currentTarget)
      text = el.val()
      @model.set('category', @options.category) unless @model.get('category')
      if text.length > 0 && !@model.get('category').isNew()
        @model.set('text', text)
        @save(e)

    remove: (e) ->
      el = $(e.currentTarget)
      if window.confirm("Are you sure you want to remove this competency and all of the associated competency traits?")
        @model.destroy(success: => el.parents('.competency-set').remove())

    addCompetency: () ->
      competencies = @model.get('competencies')
      competency = new competencies.model({text: ''})
      view = new CompetencyView(set: @, model: competency).render(true)
      @$('.competencies').append(view.el)
      @model.get('competencies').add(competency)

    updateCompanyWide: (e) ->
      checked = @$('input.company-wide').is(':checked')
      @model.set('company_wide', checked)
      @updateScopeView()

    updateScopeView: ->
      if @model.get('company_wide')
        @scopeView.disable()
      else
        @scopeView.enable()

    updateChildren: ->
      if @model.get('competencies').length > 0
        @$('.competencies').empty()
        @model.get('competencies').each (competency) =>
          view = new CompetencyView(set: @, model: competency).render()
          @$('.competencies').append(view.el)

    showErrors: (errors) ->
      @hideErrors()
      @renderErrors(errors)

    hideErrors: ->
      @$('.errors').hide()
      @$('.field-error').removeClass('field-error')

    renderErrors: (errors) ->
      @$('.errors').html(errorTemplate(errors: errors))
      @$('.errors').show()

    save: (e) ->
      @$('.save-competency-set').attr('disabled', 'disabled').text('Saving...')
      if request = @model.save()
        @hideErrors()
        request.always =>
          @$('.save-competency-set').removeAttr('disabled').text('Save Competency')
          @updateChildren()
      else
        @$('.save-competency-set').removeAttr('disabled').text('Save Competency')
        errors = @model.validationError
        @showErrors(errors)
