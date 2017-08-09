define ['backbone'], (Backbone) ->
  class PeopleOrgView extends Backbone.View
    el: '#people-list'
    initialize: ->
      @collection.on 'reset', @render, @

    render: ->
