define ['jquery', 'underscore', 'backbone',
        'templates/components/item_list'], ($, _, Backbone,
        itemListTemplate) ->
  class SimpleItemListView extends Backbone.View
    template: itemListTemplate
    events:
      'click .delete': 'onRemoveItem'
      'submit form': 'onAddItem'

    initialize: (options)->
      @$items = @$('.items')
      @$form = @$('form')
      @collection.on('add', @addItem, @)
      @collection.on('remove', @removeItem, @)

      if options.autoRender is true
        @render()

    render: ->
      @$items.empty()
      @collection.each((model) => @addItem(model))

    onRemoveItem: (e) ->
      e.preventDefault()
      $el = $(e.currentTarget)
      @collection.get($el.data('item-id')).destroy(wait: true)

    onAddItem: (e) ->
      e.preventDefault()
      @collection.create(@serializeForm(),
        wait: true
        success: _.bind(@success, @)
      )

    success: (item)->
      @clearForm()

    @clearForm: ->
      null

    addItem: (model) ->
      @$items.append @template(item: model)

    removeItem: (model) ->
      @$items.find(".item-list-#{model.id}").remove()

    serializeForm: ->
      name: @$form.find('input[name="name"]').val()
