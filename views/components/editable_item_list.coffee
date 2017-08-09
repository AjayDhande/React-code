define ['jquery', 'underscore', 'backbone',
        'views/components/editable_item'], ($, _, Backbone,
        EditableItemView) ->
  class EditableItemListView extends Backbone.View
    events:
      'click .new-item': 'onNewItem'
    itemMapping: {}
    itemView: EditableItemView

    initialize: (options)->
      @$items = @$('.items')
      @collection.on('add', @addItem, @)
      @itemView = options.itemView if options.itemView

      if options.autoRender is true
        @render()

    render: ->
      @$items.empty()
      @collection.each((model) => @addItem(model))

    onNewItem: (e) ->
      e.preventDefault()
      model = new @collection.model()
      @collection.add(model, silent: true)
      @addItem(model)

    addItem: (model) ->
      new @itemView(
        el: @addBlankItem()
        model: model
      ).render()

    addBlankItem: ->
      $('<li>', class: 'item').appendTo(@$items)
