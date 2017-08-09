define ['react', 'dom'], (React, D) ->

  React.createClass

    propTypes:
      extraClass: React.PropTypes.string

    getInitialProps:
      extraClass: ''

    render: ->
      D.div { className: "#{ @props.extraClass }" }
