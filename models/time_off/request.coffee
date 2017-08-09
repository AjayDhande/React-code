define ['backbone'], (Backbone) ->
  class TimeOffRequestModel extends Backbone.Model
    defaults:
      inactive: false

    url: ->
      "/time_off_requests/#{@id}"
