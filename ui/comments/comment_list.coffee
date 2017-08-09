define ['react',
        'dom',
        'ui/comments/comment'], (React,
        D,
        Comment) ->

  React.createClass
    commentList: ->
      if @props.limit
        @props.comments.slice(-@props.limit)
      else
        @props.comments

    render: ->
      if @props.comments.length > 0
        D.div { className: 'comments-list' }, @commentList().map (comment) ->
          Comment(comment: comment)
