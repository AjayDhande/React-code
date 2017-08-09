define ['jquery', 'underscore', 'backbone', 'utils',
        'collections/notifications',
        'templates/notifications/time_off_created',
        'templates/notifications/time_off_responded'], ($, _, Backbone, Utils,
        NotificationCollection,
        timeOffCreatedTemplate, timeOffRespondedTemplate) ->

  class NotificationDropdownView extends Backbone.View
    el: '#notifications'

    events:
      'click .dropdown-head' : 'openDropdown'
      'click .nav-notification a' : 'followLink'

    originalTitle: ''

    # This function could blow up as we add more notifications. I looking for
    # and open to suggestions on how we can break out of a case-type conditional series
    template: (notification) ->
      type = notification.get('notification_type')
      if type == 'time_off_created'
        timeOffCreatedTemplate(notification: notification.toJSON())
      else if type == 'time_off_responded'
        timeOffRespondedTemplate(notification: notification.toJSON())

    render: ->
      @collection.each (notification) => @renderAdd(notification)

    renderAdd: (notification) ->
      if @$(".nav-notification[data-id=#{ notification.id }]").length == 0
        if @$(".nav-notification").length > 0 && @$(".nav-notification:first").data('id') < notification.id
          @$notifications.prepend @template(notification)
        else
          @$notifications.append @template(notification)
      @renderIndicators()

    initialize: ->
      @$notifications = $('#dropdown-notifications')
      # $('#notifications .dropdown-contents').mouseover ->
      #   if $(document).height() > $(window).height()
      #     scrollTop = (if ($("html").scrollTop()) then $("html").scrollTop() else $("body").scrollTop())
      #     $("html").addClass("noscroll").css "top", -scrollTop
      # $('#notifications .dropdown-contents').mouseout ->
      #   scrollTop = parseInt($('html').css('top'))
      #   $('html').removeClass('noscroll')
      #   $('html,body').scrollTop(-scrollTop)
      @originalTitle = document.title
      @collection.on 'add', _.bind(@renderAdd, @)
      @collection.on 'reset', _.bind(@render, @)

      new Backbone.InfiniScroll @collection,
        pageSizeParam: 'limit'
        pageSize: 20
        target: $('#notifications .dropdown-contents')
        includePage: true
        scrollOffset: 100
        success: =>
          $('#notification-loading').slideUp 200
        error: =>
          $('#notification-loading').slideUp 200
        onFetch: =>
          $('#notification-loading').slideDown 100
      window.setInterval (=> @collection.fetch()), 60000

    openDropdown: ->
      @$el.removeClass('active')
      document.title = @originalTitle
      if $('#notifications.open').length == 0
        @collection.seeAll()
        @collection.seenThisRefresh = true

    followLink: (e) ->
      e.preventDefault()
      href = e.target.href
      $.ajax
        type: 'POST'
        url: '/notifications/' + $(e.target).parents('.nav-notification').data('id') + '/click'
        cache: false
        headers:
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        data: "{}"
        error: => console.log('oh noes')
        success: => window.location.href = href

    renderIndicators: ->
      if @collection.unseenCount() > 0
        $('#notifications').find('.count').html(@collection.unseenCount() + "")
        @$el.addClass('active')
        document.title = '(' + @collection.unseenCount() + ') ' + @originalTitle
      else
        @$el.removeClass('active')
        document.title = @originalTitle
