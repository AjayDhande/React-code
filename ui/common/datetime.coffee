define ['react', 'dom', 'moment'], (React, D, moment) ->

  React.createClass

    propTypes:
      unixTimestamp: React.PropTypes.number.isRequired
      extraClass: React.PropTypes.string
      format: React.PropTypes.string
      dateOnly: React.PropTypes.bool

    getDefaultProps: ->
      dateOnly: false
      extraClass: ''

    render: ->
      # TODO: consider the user's timezone
      d = moment(@props.unixTimestamp * 1000) # convert seconds to ms

      if @props.format
        d = d.format(@props.format)
      else
        today = moment()
        if d.clone().startOf('day').unix() == today.startOf('day').unix()
          if @props.dateOnly
            d = 'today'
          else
            d = d.fromNow()
        else
          if @props.dateOnly
            d = d.format('MMMM Do')
          else
            d = d.format('MMMM Do[,] h:mma')

      classes = ['datetime']
      classes.push(@props.extraClass) if @props.extraClass

      D.span { className: classes.join(' ') }, d
