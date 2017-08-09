define ['backbone'], (Backbone) ->
  class OfficeModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']
      address1: 'Text'
      address2: 'Text'
      city: 'Text'
      phone: 'Text'
      zip: 'Text'
      state_id: title: 'State / Province', type: 'Select', options: [{val: null, label: 'State / Province'}]
      country_id: title: 'Country', type: 'Select', options: (callback)-> callback(Namely.countries)

    defaults:
      country_id: 'US'
      state_id: 'NY'

    toString: ->
      @get('title')
