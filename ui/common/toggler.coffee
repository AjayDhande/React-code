define ['react', 'dom'], (React, D) ->

  React.createClass

    propTypes:
      text: React.PropTypes.string.isRequired
      onClick: React.PropTypes.func
      opened: React.PropTypes.bool
      disabled: React.PropTypes.bool

    getDefaultProps: ->
      opened: false
      disabled: false

    render: ->
      classes = ['toggle-container']
      classes.push('close') unless @props.opened
      classes.push('disabled') if @props.disabled
      classes.push('no-icon')
      props = { className: 'toggle' }
      props['href'] = '#' unless @props.disabled
      props['onClick'] = @props.onClick unless @props.disabled
      D.div { className: classes.join(' ')}, [
        D.a props,
          @props.text
      ]
