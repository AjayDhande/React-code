define ['jquery', 'backbone', 'utils', 'jquery.tokeninput'], ($, Backbone, Utils) ->

  class AccessRolesShowView extends Backbone.View
    el: '#access-role-form'
    events:
      'click .hide-label': 'toggleForm'
      'change input[type=checkbox]': 'toggleShowLabel'

    token_options =
      theme: "namely"
      preventDuplicates: true
      onResult: Utils.convertObjectsToTokens

    search_urls = {
      Team: '/teams/search?q=',
      CompanyDivision: '/company/settings/divisions/search?q=',
      AccessRole: '/company/settings/access-roles?q=',
      User: '/people',
    }

    toggleForm: (e) ->
      $target = $(e.target)
      target_class = $target.attr('hide')
      $target.parent().next('.hide-div').toggle()
      $target.siblings('.show-div').toggle()

    toggleShowLabel: (e) ->
      $target = $(e.target)
      data = $target.attr('data')
      if data
        $showTarget = $("#show-row-#{data}")
        if $target.is(":checked")
          $showTarget.show()
        else
          $showTarget.hide()

    initialize: ->
      $('input.exceptions, input.whitelists').each ->
        $this = $(@)
        search_url = search_urls[$this.attr('type')]
        $this.tokenInput(search_url, token_options)
