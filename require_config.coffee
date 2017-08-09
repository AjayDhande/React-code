require.config
  paths:
    jquery: '../components/jquery/jquery'
    backbone: '../components/backbone/backbone'
    underscore: '../components/underscore/underscore'
    'backbone.subroute': '../components/backbone.subroute/backbone.subroute'
    'backbone.infiniScroll': '../components/backbone.infiniScroll/lib/infiniScroll'
    'backbone.relational': '../components/backbone.relational/backbone-relational'
    'backbone-forms':      '../components/backbone-forms/distribution.amd/backbone-forms'
    'backbone-forms-templates':      'backbone-forms-pure'
    'backbone-forms-list': '../components/backbone-forms/distribution.amd/editors/list'
    runtime: '../components/jade/runtime'
    moment: '../components/moment/moment'
    overlay: 'app/overlay'
    'jquery.tablesorter': 'libs/jquery.tablesorter'
    'jquery.validate': 'libs/jquery.validate'
    'jquery.custom-file': 'libs/jquery.custom-file'
    'jquery.tokeninput': '../components/jquery.tokeninput/src/jquery.tokeninput'
    'jqueryui': 'libs/jquery-ui'
    'jqueryujs': 'libs/jquery_ujs'
    'jquery.custom-check': 'libs/jquery.custom-check'
    goog: '../components/requirejs-plugins/src/goog'
    async: '../components/requirejs-plugins/src/async'
    propertyParser: '../components/requirejs-plugins/src/propertyParser'
    plupload: 'libs/plupload/plupload.full'
    nested_form: 'libs/nested_form'
    select2: '../components/select2/select2'
    'jquery.event.drag': '../components/slickgrid/lib/jquery.event.drag-2.2'
    'jquery.event.drop': '../components/slickgrid/lib/jquery.event.drop-2.2'
    slickcore: '../components/slickgrid/slick.core'
    slickgrid: '../components/slickgrid/slick.grid'
    slickgridHeaderButtons: '../components/slickgrid/plugins/slick.headerbuttons'
    tip: '../components/tooltip/tip'
    react: '../components/react/react-with-addons.min'
    fullcalendar: '../components/fullcalendar/fullcalendar'
    backbone_model_file_upload: '../components/backbone-model-file-upload/backbone-model-file-upload'
  shim:
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    'backbone-forms-pure':
      deps: ['backbone-forms']
    'backbone.infiniScroll':
      deps: ['backbone']
    'backbone.relational':
      deps: ['backbone']
    underscore:
      exports: '_'
    runtime:
      exports: 'jade'
    moment:
      exports: 'moment'
    plupload:
      exports: 'plupload'
    overlay:
      exports: 'OVLY'
    'jqueryui':
      deps: ['jquery']
    'jqueryujs':
      deps: ['jquery']
    'jquery.custom-check':
      deps: ['jquery']
    'jquery.tablesorter':
      deps: ['jquery']
    'jquery.tokeninput':
      deps: ['jquery']
    'jquery.validate':
      deps: ['jquery']
    'jquery.custom-file':
      deps: ['jquery']
    'jquery.event.drop':
      deps: ['jquery']
    'jquery.event.drag':
      deps: ['jquery']
    select2:
      deps: ['jquery']
    slickcore:
      deps: ['jquery', 'jquery.event.drag', 'jquery.event.drop']
      exports: 'Slick'
    slickgrid:
      deps: ['slickcore']
      exports: 'Slick'
    slickgridHeaderButtons:
      deps: ['slickgrid']
    tip:
      deps: ['jquery']
