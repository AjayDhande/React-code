define ['react',
        'dom',
        'jquery',
        'underscore',
        'models/announcement',
        'models/event',
        'ui/common/loading',
        'ui/common/form_errors',
        'ui/common/user_icon',
        'utils',
        'jquery.custom-check'], (React,
        D,
        $,
        _,
        AnnouncementModel,
        EventModel,
        Loading,
        FormErrors,
        UserIcon,
        Utils) ->

  React.createClass

    # event handlers
    handleSuccess: (model, response, options) ->
      @props.events.fetch(data: { limit: 15 }).then =>
        @setState
          loading: false
          errors: []
        @refs.content.getDOMNode().value = ''
        @refs.emailAll.getDOMNode().checked = false
        @resetAnnouncement()

    handleError: (model, xhr, options) ->
      @setState
        loading: false
        focused: true
        errors: $.parseJSON(xhr.responseText)

    handleSubmit: (e) ->
      e.preventDefault()
      return false if @state.loading
      @setState
        loading: true
        focused: false
      @announcement.save(
        content: @refs.content.getDOMNode().value.trim()
        email_all: $(@refs.emailAll.getDOMNode()).is(':checked')
      )

    handleFocus: (e) ->
      @setState focused: true

    handleIconLoaded: (url) ->
      @setState iconUrl: url

    resetAnnouncement: ->
      @announcement.off(null, null, @) if @announcement
      @announcement = new AnnouncementModel
      @announcement.on 'sync', @handleSuccess, @
      @announcement.on 'error', @handleError, @

    # react
    propTypes:
      events: React.PropTypes.object.isRequired

    getInitialState: ->
      loading: false
      focused: false

    componentWillMount: ->
      @resetAnnouncement()

    componentDidMount: ->
      Utils.getProfileIcon(40, @handleIconLoaded, @)

    componentWillUnmount: ->
      @announcement.off null, null, @

    render: ->
      classes = ['update-form']
      classes.push('on') if @state.focused
      D.div { className: classes.join(' ') },
        if @state.iconUrl
          UserIcon icon: @state.iconUrl, size: 40
        D.form { onSubmit: @handleSubmit, onFocus: @handleFocus }, [
          D.textarea {
            className: 'input-content'
            placeholder: 'Share an update...'
            ref: 'content'
          }
          Loading() if @state.loading
          D.div { className: 'update-hidden clearfix' }, [
            if !_.isEmpty(@state.errors)
              FormErrors(errors: @state.errors)
            D.button { className: 'button stout-button', type: 'submit' }, 'Share'
            D.label { htmlFor: 'email-all' }, 'Email update to all'
            D.input {
              type: 'checkbox'
              name: 'email_all'
              id: 'email-all'
              ref: 'emailAll'
              className: 'custom-check'
            }
          ]
        ]
