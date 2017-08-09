define ['jquery', 'backbone'], ($, Backbone) ->
  class AppView extends Backbone.View
    el: 'body'
    events: 'click #logout': 'logout'

    back: (e) ->
      e.preventDefault()
      e.stopPropagation()

      @pageStack.pop()
      Backbone.history.navigate(@pageStack.pop(), true)

    logout: (e) ->
      e.preventDefault()
      csrf_token = $('meta[name=csrf-token]').attr('content')
      csrf_param = $('meta[name=csrf-param]').attr('content')

      params = '_method': 'delete'
      params[csrf_param] = csrf_token

      $.post '/users/logout', params, =>
        localStorage.removeItem('authToken')
        localStorage.removeItem('authHost')
        window.location.href = '/mobilelogin'

    initialize: ->
      @pageStack = []
      @counter = 0

      $(document).on @linkEvent(), "a:not([data-bypass])", (e) ->
        e.preventDefault()
        e.stopPropagation()
        Backbone.history.navigate($(this).attr("href"), true)

      $(document).on @linkEvent(), "#back-button", _.bind(@back, @)

    switchTo: (page) ->
      #$('.mobile-title').html('')

      @pageStack.push(window.location.pathname)

      @$el.attr('id', "body-#{page}")
      if page in ['details', 'members']
        $('#header-logo').hide()
      else
        $('#header-logo').show()

      window.scrollTo(0,0)

      @counter++
   
      $(document).off("scroll")

      width = $("body").width()

      $page = $("##{page}")
      $page.css('display', 'table')

      if @$current
        @$current.addClass('animate slideout')
        @hidePage(@$current, 300)

      @current = page
      @$current = $page

    hidePage: ($el, timeout) ->
      setTimeout( ->
        $el.hide()
        $el.removeClass('animate slideout')
      , timeout)

    linkEvent: ->
      if @isTouchDevice() then 'touchstart' else 'click'

    isTouchDevice: ->
      !!('ontouchstart' in window)
