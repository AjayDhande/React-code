define ['react', 'dom'], (React, D) ->

  React.createClass
    render: ->
      D.div { className: 'ajax-loader' }
