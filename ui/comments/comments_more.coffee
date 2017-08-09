define ['react',
        'ui/common/toggler',
        'dom'], (React,
        Toggler,
        D) ->

  React.createClass
    clickHandler: (e) ->
      e.preventDefault()
      @props.onClick()

    render: ->
      D.div { className: 'comments-more' }, [
        if @props.moreCommentsCount > 0
          s = (if @props.moreCommentsCount == 1 then '' else 's')
          # show all comments on click
          Toggler(
            text: "#{@props.moreCommentsCount} More Comment#{s}"
            opened: false
            onClick: @clickHandler
          )
        else if @props.canComment && !@props.formIsVisible
          # show the form on click
          Toggler(
            text: 'Add Comment'
            opened: false
            onClick: @clickHandler
            noIcon: true
          )
      ]
