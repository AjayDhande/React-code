define ['react', 'dom', 'underscore'], (React, D, _) ->

  React.createClass
    render: ->
      D.ul { className: 'form-errors' },
        (D.li {}, "#{field} #{errors.join(', ')}") for field, errors of @props.errors
