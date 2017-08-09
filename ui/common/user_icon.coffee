define ['react', 'dom'], (React, D) ->

  React.createClass

    propTypes:
      icon: React.PropTypes.string
      size: React.PropTypes.number
      extraClass: React.PropTypes.string

    getDefaultProps: ->
      size: 36
      extraClass: null

    render: ->
      classes = ["icon#{@props.size}"]
      classes.push(@props.extraClass) if @props.extraClass
      D.div { className: 'user-icon' },
        D.div { className: 'portrait' },
          D.img {
            className: classes.join(' ')
            src: @props.icon,
            width: @props.size,
            height: @props.size
          }