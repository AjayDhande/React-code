define ['backbone'], (Backbone) ->
  class TerminatedReasonModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']
