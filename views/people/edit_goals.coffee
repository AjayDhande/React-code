define ['jquery',
        'underscore',
        'backbone',
        'views/people/subgoal',
        'views/people/goal'], ($, _, Backbone, SubgoalView, GoalView) ->
  class EditGoalsView extends GoalView
    events:
      'keyup .goal-weight' : 'updateWeights'
      'add_nested_field .trigger_checker' : 'updateWeights'
      'remove_nested_field .trigger_checker' : 'updateWeights'
      'click .status input' : 'updateWeights'
      'click .toggle': 'toggleSubgoals'
      'click .add-subgoal': 'addSubgoal'
      'click .remove-subgoal': 'removeSubgoal'
      'click input.state_achieved': 'updateGoalAchievedOn'
      'click input.state_in_progress': 'updateGoalAchievedOn'
      'click input.state_no_longer_relevant': 'updateGoalAchievedOn'
      'click input.active_status_achieved': 'updateSubgoalAchievedOn'
      'click input.active_status_in_progress': 'updateSubgoalAchievedOn'
      'click input.active_status_no_longer_relevant': 'updateSubgoalAchievedOn'

    initialize: ->
      @updateWeights()
      @toggleGoals('edit-form', 'company-goals')
      @toggleGoals('edit-form', 'team-goals')
      @toggleGoals('edit-form', 'personal-goals')

      @$el.find('input.date:hidden').datepicker
        dateFormat:'yy-mm-dd'
        changeMonth:true
        changeYear:true

    updateWeights: (e) ->
      if e
        $target = $(e.target)
        $target.val(  parseInt($target.val()) || 0 )

      sum = 0
      @$('.weight_summary').empty()
      @$('.goal-row').each (index,target) =>
        $target = $(target)
        is_active = ($target.find(".state_in_progress").is(':checked') && !$target.find(".is_hidden").is(':checked') && $target.is(":visible"))
        if is_active
          weight = parseInt($target.find(".goal-weight").val())
          sum += weight

      @$('.goal-row').each (index,target) =>
        $target = $(target)
        is_active = ($target.find(".state_in_progress").is(':checked') && !$target.find(".is_hidden").is(':checked'))
        if is_active
          weight = parseInt($target.find(".goal-weight").val())
          weight_percentage = (weight / sum) * 100
          weight_summary = $target.find(".weight_summary")
          weight_summary.html("Weight Percentage: #{weight_percentage.toFixed(1)}%")

    updateGoalAchievedOn: (e) ->
      target = $(e.currentTarget)
      date = target.parent().parent().parent().find('.achieved-on input.date')
      if target.attr('class') == 'state_achieved'
        date.val($.datepicker.formatDate('yy-mm-dd', new Date()));
        date.parent().show()
      else
        date.val('')
        date.parent().hide()

    updateSubgoalAchievedOn: (e) ->
      target = $(e.currentTarget)
      date = target.parent().parent().parent().parent().find('.achieved-on input.date')

      if target.attr('class') == 'active_status_achieved'
        date.val($.datepicker.formatDate('yy-mm-dd', new Date()));
        date.parent().show()
      else
        date.val('')
        date.parent().hide()

    removeSubgoal: (e) ->
      target = $(e.target)
      subgoals = target.parent().parent().parent()
      toggle = subgoals.parent().parent().find('.toggle')
      target.parent().parent().remove()
      @updateSubgoalToggle(toggle, subgoals, true)

    findNextId: ($subgoals) ->
      if $subgoals.length
        ids = $subgoals.map((index, e) ->
          $(e).data('id')
        ).get()
        id = _.max(ids)
        id = 0 if id < 0 # To fix the existing -Infinity ids that exist on live
        id + 1
      else
        1

    addSubgoal: (e) ->
      $target = $(e.target)
      $holder = $target.parents('.goal-row')
      $destroyinput = $holder.find('input[type=hidden]').last()
      $subgoals = $holder.find('.subgoal')
      $container = $holder.find('.subgoals')
      $toggle = $holder.find('.toggle')
      # Seems to be the only way to get the data from these nested form objects
      prefix = $destroyinput.attr('id').substring(0, $destroyinput.attr('id').length - 9)
      name = $destroyinput.attr('name').substring(0, $destroyinput.attr('name').length - 10)
      id = @findNextId($subgoals)
      title = $target.data('title')
      subgoalView = new SubgoalView(prefix: prefix, name: name, id: id, title: title).render().el
      $container.prepend(subgoalView)
      $(subgoalView).find('input.date').datepicker
        dateFormat:'yy-mm-dd'
        changeMonth:true
        changeYear:true
      today = $.datepicker.formatDate('yy-mm-dd', new Date())
      $(subgoalView).find('.assigned-on input').val(today)
      $container.show()
      @updateSubgoalToggle($toggle, $container, true)

    toggleSubgoals: (e) ->
      target = $(e.target)
      subgoals = target.parent().find('.subgoals')
      @updateSubgoalToggle(target, subgoals)
      subgoals.toggle()

    updateSubgoalToggle: (target, container, show) ->
      toggle = target.find('.toggle-subgoals')
      length = container.find('.subgoal').length

      if length == 0
        toggle.parent().removeClass('hidden')
        toggle.parent().addClass('hidden')
      else
        toggle.parent().removeClass('hidden')
        toggle.find('.size').html(length)

      if show or container.is(':hidden')
        target.removeClass('close')
        target.addClass('open')
      else
        target.removeClass('open')
        target.addClass('close')
