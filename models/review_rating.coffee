define ['backbone'], (Backbone) ->
  class ReviewRatingModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']
      short_title: title: 'Short Title', type: 'Text', validations: ['required']
      color: type: 'Text', validations: ['required']

    defaults:
      color: '#333'
