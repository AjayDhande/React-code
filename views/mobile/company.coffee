define ['jquery', 'backbone', 'mobile_utils',
        'templates/mobile/company'], ($, Backbone, MobileUtils, template) ->
  class CompanyView extends Backbone.View
    el: '#company'
    template: template

    render: ->
      @$el.html(@template(company: @model.toJSON()))
      @$('a.address-icon').attr('href', (index, attr) -> MobileUtils.mapLink(attr))
      @
    
     
      
