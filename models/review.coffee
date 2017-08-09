define ['backbone'], (Backbone) ->
  class ReviewModel extends Backbone.Model
    defaults:
      inactive: false

    url: ->
      "/performance/reviews/#{@id}"

    indexText: ->
      @_indexText ?= "#{@get('reviewee_name')} #{@get('reviewee_title')} #{@get('due_date')}".toLowerCase()

    match: (value) ->
      @indexText().indexOf(value) >= 0
    fetch: (options)->
      options ?= {}
      options.data = _.extend({}, @filterParams, @orderParams, options.data || {})
      super(options)
    find_question: (id)->
      _.find(@get("questions"), (question)=>question["id"] == id)
