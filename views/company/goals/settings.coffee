define ['backbone'], (Backbone) ->
  class GoalsSettingsView extends Backbone.View
    initialize: ->
      $("#company_goals_profile_text").height($("#company_goals_profile_text")[0].scrollHeight)
