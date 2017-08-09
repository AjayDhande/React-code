define ['jquery', 'backbone', 'utils'], ($, Backbone, Utils) ->
  class SelectEditor extends Backbone.View
    events:
      'click .edit': 'onEdit'
      'click .set': 'onSet'
      'click .remove': 'onRemove'

    initialize: ->
      @$select = @$('.select')
      @$name = @$('.name')
      @$edit = @$('.edit')
      @$input = @$('.select input')
      @$remove = @$('.remove')
      @$set = @$('.set')
      @$input.tokenInput "/people",
        theme:"namely",
        tokenLimit:1,
        preventDuplicates:true,
        onResult: Utils.convertObjectsToTokens

      if @$input.val() != ''
        @$remove.show()

    onEdit: (e) ->
      e.preventDefault()
      @$name.hide()
      @$remove.hide()
      @$edit.hide()
      @$select.show()
      @$set.show()

    onRemove: (e) ->
      e.preventDefault()
      @$remove.hide()
      @$name.text('Nobody')
      @$input.tokenInput("clear")

    onSet: (e) ->
      e.preventDefault()
      obj = @$input.tokenInput("get")
      if obj.length > 0
        @$name.text(obj[0].name)
        @$remove.show()
      else
        @$name.text('Nobody')
      @$name.show()
      @$edit.show()
      @$select.hide()
      @$set.hide()
