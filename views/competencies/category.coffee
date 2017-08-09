define ['backbone',
        'templates/competencies/category',
        'views/competencies/set',
        'models/competencies/set'], (Backbone,
        template,
        CompetencySetView,
        CompetencySetModel) ->
  class CompetencyCategoryView extends Backbone.View
    className: 'competency-category'
    events:
      'click a.add-competency-set': 'addCompetencySet'
      'click a.remove-competency-category': 'removeCompetencyCategory'
      'change input.category-text': 'update'

    initialize: ->
      _.bindAll(@)

    addCompetencySet: (e) ->
      set = new CompetencySetModel(text: '')
      @model.get('sets').add(set)
      view = new CompetencySetView(model: set, category: @model).render()
      @$('.competency-sets').append(view.el)

    updateCompetencyCounter: (counter) ->
      count = 0
      @model.get('sets').each (set) => count = count + set.get('competencies').length
      if count > 1
        counter.html("#{count} Competency Traits")
      else if count == 1
        counter.html("1 Competency Trait")
      else
        counter.html("")

    render: ->
      @$el.html(template(category: @model))
      counter = @$('.competency-counter')
      @updateCompetencyCounter(counter)
      render = false
      @$('.toggle-competency-categories').click (e) =>
        unless render
          @model.get('sets').each (set) =>
            view = new CompetencySetView(category: @model, model: set).render()
            @$('.competency-sets').append(view.el)
          render = true
        target = $(e.target)
        toggle = target.parent()
        sets = toggle.parent().find('.content')
        sets.toggle()
        if sets.is(':hidden')
          target.attr('readonly', 'readonly')
          toggle.removeClass('close')
          toggle.addClass('close')
          @updateCompetencyCounter(counter)
        else
          target.removeAttr('readonly')
          toggle.removeClass('close')
      @

    removeCompetencyCategory: (e) ->
      el = $(e.currentTarget)
      if window.confirm("Are you sure you want to remove this competency category and all of the associated competencies?")
        @model.destroy(success: => el.parents('.competency-category').remove())

    updateChildren: ->
      if @model.get('sets').length > 0
        @$(".competency-sets").empty()
        @model.get('sets').each (set) =>
          view = new CompetencySetView(category: @model, model: set).render()
          @$('.completency-sets').append(view.el)

    update: (e) ->
      el = $(e.currentTarget)
      text = el.val()
      @model.save({text: text}, success: (category) => @updateChildren()) if text.length > 0

