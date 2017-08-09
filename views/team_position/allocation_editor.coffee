define ['jquery', 'underscore', 'backbone'
        'models/team_allocation',
        'templates/team_allocations/container',
        'templates/team_allocations/allocation_row'], ($, _, Backbone,
        TeamAllocationModel, templateContainer, templateRow) ->
  class TeamPositionAllocationEditorView extends Backbone.View
    events:
      "click #add-allocation": "click_add_allocation"
      "click .delete": "click_delete"
      
    dateOpts:
      dateFormat:'yy-mm-dd'
      changeMonth:true
      changeYear:true
    
    render: ->
      @$el.html templateContainer
      _(@collection.models).each (item) => 
        @append_allocation(item)
    
    click_add_allocation: (e) ->
      item = new TeamAllocationModel()
      @append_allocation item
    
    click_delete: (e) ->
      @$(e.target).parents('.row').remove()
    
    append_allocation: (item) ->
      html = templateRow
        model : item
      @$("#allocations-holder").append(html)
      @$("#allocations-holder").find('.allocation_date:last').datepicker(@dateOpts);

    
