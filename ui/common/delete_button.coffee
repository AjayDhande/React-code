define ['react', 'dom'], (React, D) ->

  React.createClass

    propTypes:
      onClick: React.PropTypes.func
      extraClass: React.PropTypes.string

    render: ->
      wrapperClasses = ['delete-block']
      wrapperClasses.push(@props.extraClass) if @props.extraClass

      aProps = { href: '#' }
      aProps['onClick'] = @props.onClick if @props.onClick
      aProps['title'] = @props.title if @props.title

      D.div { className: wrapperClasses.join(' ') }, [
        D.a aProps, ''
      ]
