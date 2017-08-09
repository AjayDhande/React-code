define ['jquery',
        'underscore',
        'views/components/tool_panel',
        'templates/teams/category'], ($, _,
        ToolPanelView,
        template) ->
  class TeamCategoryView extends ToolPanelView
    el: '#team-categories'

    events:
      'click .category': 'add'

    initialize: ->
      super()
      @$list = @$('#team-categories-list')
      @render()

    render: ->
      active = []
      active = @model.get('team_category_ids') if @model
      categories = Namely.teamCategories.models
      @$list.html template(categories: categories, active: active)
      @updateCategoryTitle()

    updateCategoryTitle: ->
      count = $('#team-categories-list .active').length
      if count == 0
        $('.button-tool').html("<div class='placeholder'>Select all that apply</div>")
      else if count == 1
        $('.button-tool').html("1 Category")
      else
        $('.button-tool').html("#{count} Categories")

    add: (e) ->
      name = $(e.currentTarget).data('name')
      category = _.find($('#team-categories-list .category'), (category) => $(category).data('name') == name)
      checkbox = $(category).find('input')
      if $(category).hasClass('active')
        $(category).removeClass('active')
        checkbox.prop('checked', false)
      else
        $(category).addClass('active')
        checkbox.prop('checked', true)
      @updateCategoryTitle()
