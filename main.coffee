define 'boot', ['jquery', 'utils', 'jquery.custom-check', 'jqueryujs',
                'jqueryui', 'backbone.infiniScroll', 'rails_sync'], ($, Utils) ->

  $search = $('.search-form')
  boot = ->
    $('a[href=#]').attr('href', 'javascript:;');
    #Set up the global ajax
    $.ajaxSetup
      cache: false
      error: (x, e) ->
        console.log(x, e)
      type: 'POST'

    if navigator.userAgent.toLowerCase().indexOf('msie 9') > -1
      $('body').addClass("ie9")

    $search.hover ((e) -> $search.addClass(on).find('input').addClass(on) ),
                  ((e) -> $search.removeClass(on).find('input').removeClass(on) )

    $('input[type="text"], input[type="email"], input[type="search"], input[type="password"], textarea').on 'focus', (e) ->
      $el = $(e.currentTarget).addClass('on')
      if $el.val() == $el.attr('placeholder')
        $el.val('')

    $('input[type="text"], input[type="email"], input[type="search"], input[type="password"], textarea').on 'blur', (e) ->
      $(e.currentTarget).removeClass('on')

    $('.custom-check').customCheck()

    $('.collapsable legend').on 'click', (e) ->
      $(e.currentTarget).parent().toggleClass('collapsed')

    # Event handler for all dropdowns.
    # All dropdowns have class 'dropdown' with two children 'dropdown_head' and
    # dropdown_body. If you want to use a backbone event inside of the dropdown,
    # you must add the class 'dropdown-event' to the element you want to listen to.
    $('.dropdown-body').click (e) ->
      if $(e.target).parents('.dropdown-event').length == 0 && !$(e.target).hasClass('dropdown-event')
        e.stopPropagation()
    $(document).click =>
      $('.open').removeClass('open').find('.dropdown-body').fadeOut(100).find('.dropdown-contents').slideUp(100)
    $('.dropdown').click (e) ->
      if !$(e.target).hasClass('dropdown-event')
        e.stopPropagation()
      $top = $(e.target).parents('.dropdown')
      if $top.hasClass('open')
        $top.removeClass('open').find('.dropdown-body').fadeOut(100).find('.dropdown-contents').slideUp(100)
      else
        $('.dropdown_contents').scrollTop(0)
        $('.open').removeClass('open').find('.dropdown-body').fadeOut(100).find('.dropdown-contents').slideUp(100)
        $top.addClass('open').find('.dropdown-body').fadeIn(100).find('.dropdown-contents').slideDown(100)

    # nested_form: avoid validation on hidden form
    $(document).on('nested:fieldRemoved', (event) -> $('[required]', event.field).removeAttr('required'))

    $('body').removeClass('preload');

define 'main', ['backbone', 'backbone.subroute'], (Backbone) ->
  class MainRouter extends Backbone.Router
    routes:
      "time_off_requests*sub": "timeOffRequests"
      "teams*sub": "teams"
      "divisions/:id*sub": "divisions"
      "people/org": "people"
      "people/:id*sub": "profile"
      "people*sub": "people"
      "performance/review_templates*sub": "reviewTemplates"
      "performance/review_signatures*sub": "reviewSignatures"
      "performance*sub": "performance"
      "fields*sub": "fields"
      "company/settings*sub": "companySettings"
      "company/export": "companyExport"
      "company*sub": "company"
      "system_logs*sub": "systemLog"
      "imports*sub": "import"
      "reports*sub": "reports"
      "integrations*sub": "integrations"
      "workflows*sub": "workflows"
      "events*sub": "events"
      "personal_calendar*sub": "personalCalendar"
      "*sub": "home"

    home: ->
      unless @homeRouter
        require ['routers/home'], (Router) =>
          @homeRouter = new Router('', createTrailingSlashRoutes: true)

    teams: ->
      unless @teamRouter
        require ['routers/team'], (Router) =>
          @teamRouter = new Router('teams', createTrailingSlashRoutes: true)

    divisions: ->
      unless @divisionRouter
        require ['routers/division'], (Router) =>
          @divisionRouter = new Router('divisions/:id', createTrailingSlashRoutes: true)
    people: ->
      unless @peopleRouter
        require ['routers/people'], (Router) =>
          @peopleRouter = new Router('people', createTrailingSlashRoutes: true)

    profile: ->
      require ['routers/profile'], (Router) =>
        new Router('people/:id', createTrailingSlashRoutes: true)

    company: ->
      unless @companyRouter
        require ['routers/company'], (Router) =>
          @companyRouter = new Router('company', createTrailingSlashRoutes: true)

    reviewTemplates: ->
      unless @reviewTemplatesRouter
        new require ['routers/review_templates'], (Router) =>
          @reviewTemplatesRouter = new Router('performance/review_templates', createTrailingSlashRoutes: true)

    reviewSignatures: ->
      unless @reviewSignatureRouter
        require ['routers/review_signature'], (Router) =>
          @reviewSignatureRouter = new Router('performance', createTrailingSlashRoutes: true)

    performance: ->
      unless @reviewRouter
        require ['routers/review'], (Router) =>
          @reviewRouter = new Router('performance', createTrailingSlashRoutes: true)

    timeOffRequests: ->
      unless @timeOffRequestRouter
        require ['routers/time_off_request'], (Router) =>
          @timeOffRequestRouter = new Router('time_off_requests', createTrailingSlashRoutes: true)

    fields: ->
      unless @fieldRouter
        require ['routers/field'], (Router) =>
          @fieldRouter = new Router('fields', createTrailingSlashRoutes: true)

    companySettings: ->
      unless @companySettingRouter
        require ['routers/company_settings'], (Router) =>
          @companySettingRouter = new Router('company/settings', createTrailingSlashRoutes: true)

    companyExport: ->
      unless @companyExportRouter
        require ['routers/export'], (Router) =>
          @companyExportRouter = new Router('routers/export', createTrailingSlashRoutes: true)

    systemLog: ->
      unless @systemLogRouter
        require ['routers/system_log'], (Router) =>
          @systemLogRouter = new Router('system_logs', createTrailingSlashRoutes: true)

    import: ->
      unless @importRouter
        require ['routers/import'], (Router) =>
          @importRouter = new Router('imports', createTrailingSlashRoutes: true)

    reports: ->
      unless @reportRouter
        require ['routers/reports'], (Router) =>
          @reportRouter = new Router('reports', createTrailingSlashRoutes: true)

    integrations: ->
      unless @integrationsRouter
        require ['routers/integrations'], (Router) =>
          @integrationsRouter = new Router('integrations', createTrailingSlashRoutes: true)

    workflows: ->
      unless @workflowsRouter
        require ['routers/workflows'], (Router) =>
          @workflowsRouter = new Router('workflows', createTrailingSlashRoutes: true)

    events: ->
      unless @eventRouter
        require ['routers/event'], (Router) =>
          @eventRouter = new Router('events', createTrailingSlashRoutes: true)

    personalCalendar: ->
      unless @personalCalendarRouter
        require ['routers/personal_calendar'], (Router) =>
          @personalCalendarRouter = new Router('personal_calendar', createTrailingSlashRoutes: true)

    initialize: ->
      unless window.location.pathname == '/users/login' || @notificationRouter
          require ['routers/notifications'], (Router) =>
            @notificationRouter = new Router('notifications', createTrailingSlashRoutes: false)



require ['backbone', 'main', 'boot'], (Backbone, MainRouter, boot) ->
  boot()
  new MainRouter

  if Backbone.history
    if window.history and window.history.pushState
      Backbone.history.start(pushState: true)
    else
      location.hash = '#' + location.pathname.substring(1)
      Backbone.history.start(pushState: false)

