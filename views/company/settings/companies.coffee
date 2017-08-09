define ['jquery', 'underscore', 'backbone', 'jquery.custom-file'], ($, _, Backbone) ->
  class CompaniesView extends Backbone.View
    el: '#content .content-holder'
    
    $logo: $('#company_logo_image')

    initialize: ->
      @$logo.customFile
        pretext:'Choose Image'
        selected:'Selected'
