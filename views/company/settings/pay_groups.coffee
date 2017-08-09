define ['jquery', 'underscore', 'backbone',
        'collections/pay_group',
        'views/components/editable_item',
        'views/components/confirm_destroy',
        'templates/pay_group/new', 'templates/pay_group/show' ], ($, _, Backbone,
        PayGroupCollection,
        EditableItemView,
        ConfirmDestroyView,
        newPayGroupTemplate, showPayGroupTemplate) ->
  class PayGroupsView extends Backbone.View

    itemMapping: {}
    itemView: EditableItemView
