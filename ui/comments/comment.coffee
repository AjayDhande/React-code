define ['react',
        'dom',
        'ui/common/user_icon',
        'ui/common/datetime',
        'ui/common/delete_button'], (React,
        D,
        UserIcon,
        DateTime,
        DeleteButton) ->

  React.createClass

    # event handlers
    deleteComment: (e) ->
      e.preventDefault()
      if window.confirm "Are you sure you want to delete this comment?"
        @props.comment.destroy(wait: true)

    onDestroy: (model, collection, options) ->
      collection.trigger 'sync' # trigger callbacks so new count is reflected

    # react
    propTypes:
      comment: React.PropTypes.object.isRequired

    componentWillMount: ->
      @props.comment.on 'destroy', @onDestroy, @

    componentWillUnmount: ->
      @props.comment.off null, null, @

    render: ->
      comment = @props.comment
      D.div { key: "comment-#{comment.get('id')}", className: 'comment' }, [
        UserIcon(icon: comment.get('icon'), size: 30)
        D.div { className: 'content-wrap' },
          D.a { href: "/people/#{comment.get('related_id')}", className: "user-link" },
            comment.get('full_name')
          DateTime( unixTimestamp: comment.get('created_at') )
          if comment.get('can_destroy')
            D.a { className: 'delete-comment', href: '#', onClick: @deleteComment }, 'Delete'
          D.div {
            className: 'comment-content'
            dangerouslySetInnerHTML: {
              __html: comment.get('content').split("\n").join('<br>')
            }
          }
      ]
