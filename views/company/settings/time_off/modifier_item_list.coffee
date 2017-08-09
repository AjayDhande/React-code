define ['jquery', 'underscore', 'backbone',
        'views/components/editable_item_list',
        'views/company/settings/time_off/modifier_item'], ($, _, Backbone,
        EditableItemListView,
        TimeOffModifierItemView) ->
  class TimeOffModifierItemListView extends EditableItemListView
    itemView: TimeOffModifierItemView

    onNewItem: (e) ->
      e.preventDefault()
      model = new @collection.model()
      model.set('profile_scope_id', @options.profile_scope_id)
      @collection.add(model, silent: true)
      @addItem(model)
