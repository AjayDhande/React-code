define ['jquery', 'underscore', 'backbone', 'utils',
        'jquery.tokeninput'], ($, _, Backbone, Utils, ZpEmployeeCollection, ZpEmployeeModel, template) ->
  class EmployeeSyncView extends Backbone.View
    el: "#employee-sync"
    render: ->
      options =
        theme: "namely"
        tokenLimit: 1
        preventDuplicates: true
        onResult: Utils.convertObjectsToTokens

      @$(".tokeninput").tokenInput('/people', options)
      console.log "here"
