define ['backbone',
        'templates/holiday/holiday'], (Backbone,
        template) ->
  class HolidayView extends Backbone.View
    tagName: 'tr'
    className: 'holiday'

    events:
      'change .holiday-name input': 'updateName'
      'change .holiday-date input': 'updateDate'
      'click .delete-holiday': 'deleteHoliday'

    updateName: (e) ->
      $target = $(e.currentTarget)
      @update('name', $target.val())

    updateDate: (e) ->
      $target = $(e.currentTarget)
      @update('date', $target.val())

    update: (attribute, value) ->
      @model.set(attribute, value)

    render: ->
      @$el.html(template(holiday: @model, id: Date.now()))
      @

    deleteHoliday: (e) ->
      e.preventDefault()
      @model.set('_destroy', true)
      holidays = @$el.parent()
      if holidays.find('.holiday').length == 1
        holidays.find('.header').hide()
      @remove()
