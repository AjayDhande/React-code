define ['backbone'], (Backbone) ->
  class IcalendarTokenModel extends Backbone.Model

    url: ->
      if @isNew()
        return "/sync_cal"
      else
        return "/sync_cal/#{@get('id')}"

    idAttribute: 'id'