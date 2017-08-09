define ['jquery'], ($) ->
  class MobileUtils
    @mapLink: (link) ->
      if window.navigator.userAgent.match(/like Mac OS X/i)
        "maps:q=#{link}"
      else
        "geo:0,0?q=#{link}"

    @isIOS: ->
      ua = navigator.userAgent
      (ua.indexOf('iPhone') != -1) or (ua.indexOf('iPod') != -1) or (ua.indexOf('iPad') != -1)
