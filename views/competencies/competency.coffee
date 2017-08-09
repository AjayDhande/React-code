define ['backbone', 'templates/competencies/competency'], (Backbone, template) ->
  class CompetencyView extends Backbone.View
    className: 'competency'

    initialize: ->
      _.bindAll(@)

    render: (focus = false) ->
      @$el.html(template(competency: @model))
      text = @$('input.competency-text')
      text.on('blur', @update)
      text.on('keydown', @edit)
      @$('a.remove-competency').click(@removeCompetency)
      text.focus() if focus
      @

    edit: (e) ->
      target = $(e.currentTarget)
      if (e.keyCode == 8 || e.keyCode == 46)
        if target.val().length == 0
          e.preventDefault()
          @removeCompetency(e)
      else if e.keyCode == 13
        e.preventDefault()
        @options.set.addCompetency()

    removeCompetency: (e) ->
      el = $(e.currentTarget)
      if window.confirm("Are you sure you want to remove this competency trait?")
        @model.destroy(success: => el.parents('.competency').remove())

    update: (e) ->
      el = $(e.currentTarget)
      text = el.val()
      @model.set('competency-set', @options.set.model) unless @model.get('competency-set')
      @model.save({text: text}) if text.length > 0 && !@model.get('competency-set').isNew()
