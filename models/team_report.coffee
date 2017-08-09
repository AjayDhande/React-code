define ['backbone'], (Backbone) ->
  class TeamReportModel extends Backbone.Model
    url: -> "/teams/#{ @team.get('guid') }/org-chart-info"
    initialize: (options) ->
      @team = options.team

