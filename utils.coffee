define ['underscore', 'jquery'], (_, $) ->
  class Utils
    @unserializeParams: (query) ->
      params = {}
      if query
        query = query.replace(/^\?/, '').split(/&/)
        for pair in query
          pair = pair.split('=')
          params[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1])
      params

    @stripTrailingSlash: (str) ->
      if str.substr(-1) is "/"
        str.substr(0, str.length - 1)
      else
        str

    @clickDiv: ->
      @bindAction ?= if @isIOS() then 'touchstart' else 'click'

    @isIOS: ->
      ua = navigator.userAgent
      (ua.indexOf('iPhone') != -1) or (ua.indexOf('iPod') != -1) or (ua.indexOf('iPad') != -1)

    @convertObjectsToTokens: (results) ->
      if 'people' of results and results.people instanceof Array
        return results.people

      else if 'objects' of results and results.objects instanceof Array
        return results.objects

      return results

    @setupDatePicker: ($master = $('body'), selector = 'input.date') ->
      $master.on('focus', selector, ->
        $(@).datepicker(
          dateFormat: 'yy-mm-dd'
          changeMonth: true
          changeYear: true
        )
      )

    @workingDaysBetweenDates: (startDate, endDate) ->
      millisecondsPerDay = 86400 * 1000
      startDate.setHours(0,0,0,1)
      endDate.setHours(23,59,59,999)
      diff = endDate - startDate
      days = Math.ceil(diff / millisecondsPerDay)

      weeks = Math.floor(days / 7)
      days = days - (weeks * 2)

      startDay = startDate.getDay()
      endDay = endDate.getDay()

      if (startDay - endDay > 1)
          days = days - 2
      if (startDay == 0 && endDay != 6)
          days = days - 1
      if (endDay == 6 && startDay != 0)
          days = days - 1

      return days

    @cached_profile_icons: {}

    @getProfileIcon: (size, callback, context) ->
      context = context || @
      if typeof @cached_profile_icons[size] == 'string'
        callback.call(context, @cached_profile_icons[size])
      else if typeof @cached_profile_icons[size] == 'object'
        # add our callback + context to the array
        @cached_profile_icons[size].push({
          callback: callback
          context: context
        })
      else
        # initialize our array of callbacks
        @cached_profile_icons[size] = [{
          callback: callback
          context: context
        }]
        # fetch it
        $.get('/utils/profile_icon', { size: size }, (data) =>
          url = data.profile_icon.url
          size = data.profile_icon.size
          # loop through callbacks and call them
          obj.callback.call(obj.context, url) for obj in @cached_profile_icons[size]
          # set the size so it's cached for later
          @cached_profile_icons[size] = url
        )
      # return nothing - uses callbacks
      null
