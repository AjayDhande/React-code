define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ContactInfoView extends Backbone.View
    el: '#employee-form'

    events:
      'click #edit-user-info': 'edit',
      'submit': 'submit'

    initialize: ->
      @$editButton = $('#edit-user-info')

    edit: (e) ->
      e.preventDefault()
      $('#edit-user-info').hide()
      @$('.info-text').hide()
      @$('input').show()
      @$('button').show()
      false

    submit: (e) ->
      e.preventDefault()
      $.ajax
        url: @$el.attr('action')
        data: @$el.serialize()
        dataType: 'json'
        success: (data) =>
          if data.success is true
            $("#edit-user-info").show()
            @$("input[type='text']").each ->
              $this = $(@)
              $this.siblings('.info-text').text($this.val())
              $this.hide()

            @$('.info-text').show()
            @$('button').hide()
          else
            alert('Error happened')
        error: -> alert('Error happened')



