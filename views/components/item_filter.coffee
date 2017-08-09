define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ItemFilterView extends Backbone.View
    instantSearch: false
    searchField: null
    initialize: ->
      @$form = @$('form')
      if @instantSearch and @searchField
        @$searchField = @$(@searchField)
        @$searchField.keyup (e) =>
          if @timeout
            clearTimeout(@timeout)
          if @$searchField.val().length != 1
            @timeout = setTimeout((=> @trigger('change', @serializeForm())), 200)

      @$form.submit (e)=>
        e.preventDefault()
        @trigger 'change', @serializeForm()
