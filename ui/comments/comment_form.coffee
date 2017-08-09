define ['react',
        'dom',
        'jquery',
        'underscore',
        'ui/common/loading',
        'ui/common/form_errors',
        'ui/common/user_icon',
        'utils'], (React,
        D,
        $,
        _,
        Loading,
        FormErrors,
        UserIcon,
        Utils) ->

  React.createClass
    # handlers
    handleSubmit: (e) ->
      e.preventDefault()
      content = @refs.content.getDOMNode().value.trim()

      @setState loading: true

      @props.comments.create { content: content }, {
        wait: true
        success: (collection, model) =>
          if @isMounted()
            @setState
              loading: false
              errors: []
            @refs.content.getDOMNode().value = ''
          if typeof @props.handleSuccess == 'function'
            # HACK - but if we do not delay, we get this react error
            #
            # Uncaught Error: Invariant Violation: ReactMount: Two valid but
            # unequal nodes with the same `data-reactid`
            setTimeout @props.handleSuccess, 1
        error: (collection, xhr, options) =>
          @setState
            loading: false
            errors: $.parseJSON(xhr.responseText)
          @refs.content.getDOMNode().focus()
      }

    handleFocus: ->
      @setState focused: true

    handleIconLoaded: (url) ->
      if @isMounted()
        @setState iconUrl: url

    # react
    getInitialState: ->
      loading: false
      focused: false
      iconUrl: null
      errors: []

    componentDidMount: ->
      if @props.autofocus
        @refs.content.getDOMNode().focus()
      Utils.getProfileIcon(30, @handleIconLoaded, @)

    render: ->
      D.div {}, [
        if @state.loading
          Loading()
        else
          formClasses = ['comment-form']
          formClasses.push('on') if @state.focused
          D.form {
            onSubmit: @handleSubmit
            className: formClasses.join(' ')
          }, [
            if @state.iconUrl
              UserIcon icon: @state.iconUrl, size: 30
            D.div { className: 'content-wrap clearfix' },
              if !_.isEmpty(@state.errors)
                D.textarea {
                  className: 'input-with-error'
                  placeholder: 'Please enter text...'
                  ref: 'content'
                  onFocus: @handleFocus
                }
               else
                D.textarea {
                  placeholder: 'Post a comment...'
                  ref: 'content'
                  onFocus: @handleFocus
                }
              if @state.focused
                D.button {
                  type: 'submit',
                  className: 'button stout-button button-secondary'
                }, 'Post'
          ]
      ]
