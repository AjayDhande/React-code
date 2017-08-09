define ['jquery', 'underscore', 'backbone', 'utils'], ($, _, Backbone, Utils) ->
  class UserSelectView extends Backbone.View
    initialize: (options) ->
      _.bindAll(@)

    render: ->
      cp_options =
        theme: "namely"
        tokenLimit: 1
        onAdd: @addUser
        onDelete: @deleteUser
        onResult: Utils.convertObjectsToTokens

      @$el.tokenInput("/people", cp_options)

    selected: ->
      @$el.tokenInput('get').length > 0

    get: ->
      element = @$el.tokenInput('get')
      if element.length > 0
        element[0]


    addUser: (item)->
      @trigger('add', item)


    clear: ->
      @$el.tokenInput('clear')
