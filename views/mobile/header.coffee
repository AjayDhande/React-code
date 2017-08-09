define ['jquery', 'backbone'], ($, Backbone) ->
  class HeaderView extends Backbone.View
    setTitle: (title, icon, back) ->
      console.log @$el
      console.log @$('.mobile-title')
      console.log title
      if title && title != ''
        @$('.mobile-title').show();
        @$('.mobile-title').html(title)
      else
        @$('.mobile-title').hide();
      if icon
        @$('#header-logo').removeClass().addClass(icon)
      if back
      	@$('#back-button').show()
      else
      	@$('#back-button').hide()
