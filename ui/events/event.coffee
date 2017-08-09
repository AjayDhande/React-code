define ['react',
        'dom',
        'ui/comments/comments'
        'ui/common/loading'
        'ui/common/icon',
        'ui/common/user_icon',
        'ui/common/datetime',
        'ui/common/delete_button'], (React,
        D,
        Comments,
        Loading,
        Icon,
        UserIcon,
        DateTime,
        DeleteButton) ->

  EventDate = React.createClass
    getDefaultProps: ->
      dateOnly: true

    render: ->
      date = DateTime(
        unixTimestamp: @props.event.get('created_at')
        dateOnly: @props.dateOnly
      )
      if @props.standalone
        date
      else
        D.a { href: @props.event.get('href') }, date

  TeamStart = React.createClass
    render: ->
      event = @props.event
      D.div {className: 'event-teamstart'}, [
        D.span { className: 'event-icon' }, ''
        D.a { href: "/teams/#{ event.get('team_id')}" }, event.get('team_name')
        {" started."}
        EventDate(
          event: event
          standalone: @props.standalone
        )
      ]

  Anniversary = React.createClass
    render: ->
      event = @props.event
      D.div {className: 'event-anniversary' }, [
        D.span { className: 'event-icon' }, ''
        {"Celebrate "}
        D.a { href: "/people/#{ event.get('related_id')}" }, [
          D.img { src: event.get('avatar_url'), alt: event.get('related_name'),
          className: 'event-head-image'}
          D.span {}, "#{ event.get('related_name') }'s "
        ]
        D.span { className: 'years' }, event.get('years_at_company')
        {"-year anniversary!"}
        EventDate(
          event: event
          standalone: @props.standalone
        )
      ]

  Birthday = React.createClass
    render: ->
      event = @props.event
      D.div {className: 'event-birthday'}, [
        D.span { className: 'event-icon' }, ''
        {"Celebrate "}
        D.a { href: "/people/#{ event.get('related_id')}" }, [
          D.img { src: event.get('avatar_url'), alt: event.get('related_name'),
          className: 'event-head-image'}
          D.span {}, "#{ event.get('related_name') }'s"
        ]
        {" birthday!"}
        EventDate(
          event: event
          standalone: @props.standalone
        )
      ]

  Announcement = React.createClass
    deleteAnnouncement: (e) ->
      e.preventDefault()
      if (window.confirm("Are you sure you want to delete this announcement?"))
        @props.event.announcement().destroy(
          wait: true
          success: =>
            if @props.standalone
              # HACK!
              window.location.href = '/'
            else
              # manually call remove() on the collection b/c of the announcement >
              # event relationship
              @props.event.collection.remove(@props.event)
        )

    render: ->
      event = @props.event
      announcement = event.announcement()
      D.div {className: 'event-announcement'}, [
        D.div { className: 'icon-holder' }, [
          UserIcon(icon: announcement.get('user_icon'), size: 40)
        ]
        if announcement.get('can_destroy')
          DeleteButton(
              extraClass: 'delete-event'
              onClick: @deleteAnnouncement
              title: 'Delete'
          )

        D.div { className: 'post-holder' }, [
          D.div { className: 'metadata-holder' }, [
            D.a { href: "/people/#{@props.event.get('related_id')}" },
              @props.event.get('related_name')
            EventDate(
              event: event
              standalone: @props.standalone
              dateOnly: false
            )
          ]
          D.div {
            className: 'post'
            dangerouslySetInnerHTML: { __html: announcement.get('content') }
          }
        ]
        D.div { className: 'clear' }
      ]


  # this is the actual module we pass back to requirejs
  Event = React.createClass

    eventComponentMap:
      team_start: TeamStart
      birthday: Birthday
      announcement: Announcement
      anniversary: Anniversary

    # event handlers
    handleSynced: ->
      @setState loading: false

    # react
    getInitialState: ->
      loading: false

    componentWillMount: ->
      if @props.standalone
        @setState loading: true
        @props.event.on 'sync', @handleSynced, @
        @props.event.fetch()

    componentWillUnmount: ->
      @props.event.off null, null, @

    render: ->
      if @state.loading
        Loading()
      else
        event = @props.event
        D.div {
          key: "event-#{event.get('id')}"
          className: 'event content-with-bg clearfix'
        }, [

          D.div { className: 'event-content' },
            @eventComponentMap[event.get('type')](
              event: event
              standalone: @props.standalone
            )

          if event.get('use_comments')
            Comments(
              comments: event.get('comments'),
              canComment: event.get('can_comment')
              showAll: @props.standalone
            )
        ]
