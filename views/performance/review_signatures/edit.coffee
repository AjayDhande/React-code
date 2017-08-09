define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ReviewSignatureEditView extends Backbone.View
    el: 'form.edit_review_signature'

    events:
      'click #review_signature_signed': 'signButton'

    signButton: (e) ->
      target = $(e.target)
      button = target.parent().children('input.sign')
      button.prop('disabled', !target.prop('checked'))
