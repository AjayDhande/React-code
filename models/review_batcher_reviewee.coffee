define ['backbone'], (Backbone) ->
  class ReviewBatcherRevieweeModel extends Backbone.Model

    url: -> 
      "/performance/review_batchers/#{@get('batch_id')}/reviewees/#{ @get('id') }"
