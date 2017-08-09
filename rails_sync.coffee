define ['backbone', 'underscore'], (Backbone, _) ->
  sync = Backbone.sync
  Backbone.sync = (method, model, options) ->
    beforeSend = options.beforeSend
    options = _.extend(
      beforeSend: (xhr) ->
        if !options.noCSRF
          token = $('meta[name="csrf-token"]').attr('content')
          if token
            xhr.setRequestHeader('X-CSRF-Token', token)
        beforeSend(xhr) if beforeSend
    , options)

    sync(method, model, options)
