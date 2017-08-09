define ['jquery', 'backbone',
        'templates/mobile/search'], ($, Backbone, template) ->
  class SearchView extends Backbone.View
    template: template
    events:
      'keyup .search-field': 'search'
      'submit form': 'search'
      'click .clear-button': 'clearSearch'
      'focus .search-field': 'focus'
      'blur .search-field': 'blur'

    value: ->
      $.trim(@$field.val().toLowerCase())

    focus: (e) ->
      $('html,body').animate scrollTop: 0

    blur: (e) ->
      $('header').css('position','fixed').css('top','0px')
      @trigger('search')

    search: (e) ->
      e.preventDefault()
      
      
      @$('.clear-button').css('display', 'none')
      if @value().length != 1
        @trigger('search')

    clearSearch: (e) ->
      e.preventDefault()
      if @timeout
        clearTimeout(@timeout)

      @$('input[type="search"]').val('')
      @$('.clear-button').css('display', 'none')
      @trigger('search')


    ignore: (e) ->
      e.preventDefault()

    clear: ->
      @$el.empty()

    render: ->
      @$el.html(@template(name: @options.name)).hide()
      @$field = @$('.search-field')
      $('#search').append(@$el)
