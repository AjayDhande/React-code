require.config
  paths:
    jquery: 'libs/jquery2'
    backbone: '../components/backbone/backbone'
    underscore: '../components/underscore/underscore'
    runtime: '../components/jade/runtime'
  shim:
    runtime:
      exports: 'jade'
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'

window.Namely =
  permalink: 'namely'

require ['backbone'
         'collections/favorite',
         'collections/person',
         'collections/team',
         'collections/division',
         'models/company',
         'models/team',
         'models/division',
         'views/mobile/app',
         'views/mobile/company',
         'views/mobile/teams',
         'views/mobile/favorites',
         'views/mobile/home',
         'views/mobile/people',
         'views/mobile/person',
         'views/mobile/team',
         'views/mobile/division',
         'views/mobile/header'], (Backbone,
         FavoriteCollection, PersonCollection, TeamCollection, DivisionCollection,
         CompanyModel, TeamModel, DivisionModel,
         AppView, CompanyView, TeamsView, FavoritesView, HomeView, PeopleView,
         PersonView, TeamView, DivisionView, HeaderView) ->
  try
    window.navigator.splashscreen.hide()
  catch e
    console.log(e)

  Backbone.history.on 'route', (name, args) ->
    url = Backbone.history.getFragment()
    if !/^\//.test(url) && url != ""
      url = "/" + url
    if window._gaq?
      window._gaq.push(['_trackPageview', url])

  class MobileRouter extends Backbone.Router
    routes:
      'm': 'home'
      '': 'home'
      'm/company': 'company'
      'm/people': 'people'
      'm/people/:personId': 'person'
      'm/teams': 'teams'
      'm/teams/:teamId': 'team'
      'm/divisions/:divisionId': 'division'
      'm/favs': 'favs'
      'm/': 'home'

    initialize: ->
      @appView = new AppView

      Namely.favorites = new FavoriteCollection
      Namely.favorites.fetch(reset: true)
      @headerView = new HeaderView(el: $('header'))
      Namely.people = new PersonCollection
      Namely.people.fetch(reset: true, data: {simple: true})

      Namely.company = new CompanyModel
      Namely.company.fetch
        reset: true
        success: =>
          @companyView = new CompanyView(model: Namely.company, headerView: @headerView)
          @companyView.render()

      Namely.teams = new TeamCollection
      Namely.teams.fetch(reset: true)

      Namely.divisions = new DivisionCollection
      Namely.divisions.fetch(reset: true)


      @teamsView = new TeamsView(teams: Namely.teams, divisions: Namely.divisions, headerView: @headerView)
      @favoritesView = new FavoritesView(headerView: @headerView)
      @homeView = new HomeView(headerView: @headerView)
      @peopleView = new PeopleView(headerView: @headerView)
      
      
    removeSearch: ->
      $('#search > *').hide()

    home: ->
      @removeSearch()
      @homeView.render()
      @appView.switchTo('home')

    company: ->
      @headerView.setTitle('Company', 'header-home')
      @removeSearch()
      @appView.switchTo('company')

    people: ->
      @peopleView.focus()
      @appView.switchTo('people')

    person: (personId) ->
      @removeSearch()
      if @personView
        @personView.remove()


      @personView = new PersonView(personId: personId,headerView: @headerView)
      @personView.focus()
      @appView.switchTo('details')

    teams: ->
      @teamsView.focus()
      @appView.switchTo('teams')

    team: (teamId) ->
      @removeSearch()
      if !(Namely.teams && team = Namely.teams.get(teamId))
        team = new TeamModel(id: teamId, guid: teamId)
        team.fetch()
      @teamView = new TeamView(model: team, headerView: @headerView)
      @appView.switchTo('members')

    division: (divisionId) ->
      @removeSearch()
      if Namely.divisions || Namely.divisions.models.length == 0
        Namely.divisions.fetch(success: =>
          division = Namely.divisions.get(divisionId)
          @divisionView = new DivisionView(model: division, headerView: @headerView)
          @appView.switchTo('members'))

    favs: ->
      @removeSearch()
      @headerView.setTitle('favorites', 'header-home')
      @appView.switchTo('favs')

  new MobileRouter
  Backbone.history.start(pushState: true)
