define ['backbone'], (Backbone) ->
  class TeamAllocationModel extends Backbone.Model
    defaults:
      id: null
      allocation: 100
      date: ''
      is_default_start: false
