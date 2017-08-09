define ['jquery', 'backbone',
        'views/mobile/search',
        'templates/mobile/team_list',
        'templates/mobile/empty'], ($, Backbone,
        SearchView, template, emptyTemplate) ->
  class TeamsView extends Backbone.View
    el: '#teams'
    template: template

    initialize: ->
      @$list = @$('.list')
      @options.teams.on('reset', @refresh, @)
      @options.divisions.on('reset', @refresh, @)
      @searchView = new SearchView(name: 'Team')
      @searchView.on('search', _.bind(@refresh, @))
      @searchView.render()
      @refresh()

    refresh: ->
      value = @searchView.value()
      collection = @options.teams.where(status: 'active')
      collection = collection.concat @options.divisions.models
      if value
        @list = _.filter collection, (team) ->
          name = team.get('name') || team.get('title')
          name.toLowerCase().indexOf(value) >= 0
        @searching = true
      else
        @list = collection
        @searching = false
      @render()

    focus: ->
      @options.headerView.setTitle('Teams', 'header-home')
      @searchView.$el.show()

    render: ->
      if @list.length > 0
        teams = _.map @list, (team) -> team.toJSON()
        @$list.html(@template(teams: {teams: teams}) + '<h1 class="grey-namely-end-list"><span aria-hidden="true" class="ic grey-namely"></span></h1>')
      else
        if @searching
          @$list.html(emptyTemplate(message: 'There are no results for your search criteria.'))
        else
          @$list.html(emptyTemplate(message: 'Loading...'))
      
