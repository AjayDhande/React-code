define ['backbone',
        'templates/updates/form'], (Backbone,
        template) ->
  class UpdateFormView extends Backbone.View
    el: "#update"
    events:
      "submit .update-form": "submit"
      "click textarea[name='content']" : "expand"

    initialize: ->
      if $('#update').length > 0
        @render()

    render: ->
      @$el.html template()
      @$el.addClass("off")
      $(document).mouseup(@shouldCollapse)
      @

    submit: (e)->
      e.preventDefault()
      update = @collection.create
        content: @$("textarea[name='content']").val()
        notification_email: @$("input[name='notification-email']").is(":checked")
      ,
        success: =>
          @options.eventCollection.fetch()
          @resetTextArea()
        error: (model, response) =>
          alert("Content #{ JSON.parse(response.responseText)['content'] }")

    expand: ->
      @$el.removeClass("off").addClass("on")

    collapse: ->
      @$el.removeClass("on").addClass("off")

    resetTextArea: ->
      @collapse()
      @$('textarea').val('')
      @$('input[type="checkbox"]').prop("checked", false)

    shouldCollapse: (e) =>
      unless ((e.target == @$el) || (@$el.find(e.target).length != 0))
        @collapse()
