define ['react',
        'dom',
        'ui/comments/comment_form',
        'ui/comments/comment_list',
        'ui/comments/comments_more',
        'ui/common/loading'], (React,
        D,
        CommentForm,
        CommentList,
        CommentsMore,
        Loading) ->

  React.createClass
    # event handlers
    handleComments: ->
      @setState
        loading: false
        formIsVisible: false

    handleFormSuccess: ->
      @setState limit: 0

    open: ->
      if @moreCommentsCount() > 0
        @showAllComments()
      else
        @showForm()

    showAllComments: ->
      @setState
        limit: 0
        formIsVisible: true
        autofocusForm: true

    showForm: ->
      @setState
        formIsVisible: true
        autofocusForm: true

    moreCommentsCount: ->
      if @state.limit
        @props.comments.length - @state.limit
      else
        0

    # react
    getInitialState: ->
      loading: false
      commentsAreVisible: true
      formIsVisible: false
      autofocusForm: false
      limit: 3

    componentWillMount: ->
      if @props.showAll
        @setState
          limit: 0
          formIsVisible: true
      @props.comments.on 'add remove sync', @handleComments, @

    componentWillUnmount: ->
      @props.comments.off null, null, @

    render: ->
      moreCommentsCount = @moreCommentsCount()
      D.div { className: 'comments' }, [
        if @state.loading
          Loading()
        if @state.commentsAreVisible && @props.comments.length > 0
          CommentList(comments: @props.comments, limit: @state.limit)
        if moreCommentsCount > 0 || @props.canComment
          D.div { className: 'comment-form-holder' }, [
            CommentsMore(
              moreCommentsCount: @moreCommentsCount(),
              canComment: @props.canComment,
              formIsVisible: @state.formIsVisible,
              onClick: @open
            ),
            if @props.canComment && @state.formIsVisible
              CommentForm
                comments: @props.comments
                autofocus: @state.autofocusForm
                handleSuccess: @handleFormSuccess
          ]
      ]
