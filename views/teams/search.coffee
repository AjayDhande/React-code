define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class AccountSearchView extends Backbone.View
    keystrokeCallback: null
    keystrokeCallbackTime: 200
    el: '#team-search'
    events:
      'keyup': 'search'

    reset: ->
      @$el.val(@$el.attr('placeholder'))

    search: (e) ->
      clearTimeout(@keystrokeCallback)
      keycode = if e.keyCode then e.keyCode else e.which
      if keycode == '13'
        @searchOnStrings()
      else
        @keystrokeCallback = setTimeout(_.bind(@searchOnStrings, @),
          @keystrokeCallbackTime)

    searchOnStrings: ->
      $teamListItems = $('#team-list').find('li')
      searchText = $.trim(@$el.val().toLowerCase()).replace(RegExp(" +", "g"), ' ')
      targetedItems = []
      unTargetedItems = []
      $teamListItems.each (index, item) =>
        $el = $(item)
        title = $el.find('h3').html().replace(/\s+/g, ' ').toLowerCase()
        if title.search(searchText) >= 0
          targetedItems.push(item)
        else
          unTargetedItems.push(item)

        if targetedItems
          $(targetedItems).fadeIn()
        if unTargetedItems
          $(unTargetedItems).fadeOut()

        @.options.indexView.resetCategoryButton()
