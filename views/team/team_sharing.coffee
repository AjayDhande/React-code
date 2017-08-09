define ['jquery', 'underscore', 'backbone',
        'views/components/simple_item_list',
        'views/components/user_select',
        'templates/team/collaborator'], ($, _, Backbone,
        SimpleItemListView,
        UserSelectView, template) ->
  class TeamSharingView extends SimpleItemListView
    template: template
    initialize: (options)->
      @userSelect = new UserSelectView
        el: @$('.user-select')
      super options

    render: ->
      super()
      @userSelect.render()

    serializeForm: ->
      user = @userSelect.get()
      if user?
        user_id: user.id
        name: user.name

    clearForm: ->
      @userSelect.clear()

