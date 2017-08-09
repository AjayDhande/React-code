define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class EditGeneralOfficeLocationView extends Backbone.View
    events:
      'change #user_office_location_id': 'displayDefaults'
      
    extra: '.extra'

    fields:
      address1: 'Address 1'
      address2: 'Address 2'
      city: 'City'
      state: 'State'
      country_id: 'Country'
      zip: 'Postal Code'
      phone: 'Phone'

    displayDefaults: ->
      @$(@extra).empty()
      model = @collection.get(parseInt(@$('#user_office_location_id').val()))
      if model
        for field, label of @fields
          value = model.get(field)
          if value
            @$(@extra).append("<div class='extra_row'>#{label}: #{value}</div>")


    initialize: ->
      @displayDefaults()
      


