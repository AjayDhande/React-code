define ['backbone',
        'views/people/edit',
        'views/people/show',
        'views/people/show_time_off'], (Backbone,
        EditView,
        PersonShowView,
        ShowTimeOffView) ->

  class ProfileRouter extends Backbone.SubRoute

    routes:
      '': 'show_or_edit'
      'new': 'edit'
      'edit*type': 'edit'
      'show/time-off': 'timeOff'
      'show*type': 'show'

    edit: ->
      new EditView

    timeOff: ->
      new ShowTimeOffView

    show: ->
      new PersonShowView

    show_or_edit: (id) ->
      if id == 'new' || $('#errors').length > 0
        new EditView
      else
        new PersonShowView
