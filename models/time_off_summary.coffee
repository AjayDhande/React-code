define ['backbone'], (Backbone) ->
  class TimeOffSummaryModel extends Backbone.Model
    defaults:
      inactive: false

    url: ->
      "/time_off_requests/#{ @get('id') }/summary/#{ @get('year') }"
