define ['views/components/confirm_destroy', 
        'templates/fields/confirm_destroy'], (ConfirmDestroyView, confirmTemplate) ->
  class FieldsConfirmDestroyView extends ConfirmDestroyView
    template: confirmTemplate


