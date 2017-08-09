define ['react',
        'dom',
        'jquery',
        'ui/common/loading',
        'ui/events/event'], (React,
        D,
        $,
        Loading,
        Event) ->

  Events = React.createClass

    # event handlers
    handleSync: ->
      @setState loading: false

    # custom methods
    loadMore: ->
      if !@state.loading
        @setState loading: true

        if @props.events.length > 0
          lastId = _.min(@props.events.pluck("id"))
          data = { after: lastId, limit: 15 }
        else
          data = { limit: 15 }

        @props.events.fetch(remove: false, data: data).then =>
          @setState
            loading: false
            handlingScroll: false

    # react
    getInitialState: ->
      loading: false
      handlingScroll: true

    componentWillMount: ->
      @props.events.on 'add add:comments remove:comments sync remove', @handleSync, @

    componentDidMount: ->
      @loadMore()

      # load more when we hit the bottom of the page
      $(window).on 'scroll.posts', =>
        if !@state.handlingScroll && !@props.events.loadedAll &&
          $(window).scrollTop() + $(window).height() == $(document).height()
            @setState handlingScroll: true
            @loadMore()

    componentWillUnmount: ->
      @props.events.off null, null, @
      $(window).off 'scroll.posts'

    render: ->
      D.div {}, [
        @props.events.map (event) ->
          Event(event: event)

        Loading() if @state.loading
      ]
