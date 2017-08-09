define ['jquery', 'backbone', 'utils',
        'views/performance/review_signatures/edit'], ($, Backbone, Utils,
        ReviewSignatureEditView) ->
  class ReviewSignatureRouter extends Backbone.SubRoute
    routes:
      'review_signatures/:id/edit' : 'reviewSignatureEdit'

    reviewSignatureEdit: ->
      new ReviewSignatureEditView
