define ['jquery', 'underscore', 'backbone',
        'views/components/editable_item'], ($, _, Backbone,
        EditableItemView) ->
  inverse = (hex) ->
    return null  if hex.length isnt 7 or hex.indexOf("#") isnt 0
    r = (255 - parseInt(hex.substring(1, 3), 16)).toString(16)
    g = (255 - parseInt(hex.substring(3, 5), 16)).toString(16)
    b = (255 - parseInt(hex.substring(5, 7), 16)).toString(16)
    "#" + pad(r) + pad(g) + pad(b)
  pad = (num) ->
    if num.length < 2
      "0" + num
    else
      num

  class ReviewRatingEditableItemView extends EditableItemView
    events:
      'click .rating-color': 'fillColor'
      'keyup input[name=color]': 'changeColor'
    colors: [
        '#2B68A6',
        '#5BA8E3',
        '#AFC7DA',
        '#7E8688',
        '#82A82D',
        '#656852',
        '#EDEDE9',
        '#17130C',
        '#EAC7A7',
        '#E9AF50',
        '#D75F1E',
        '#8E4017']
    forceOrphans: true

    initialize: (options) ->
      @events = _.extend({}, EditableItemView.prototype.events, @events)
      super(options)
      @$el.attr('id', "review-rating_#{ @model.id}")

    renderForm: ->
      @form = new Backbone.Form(model: @model)
      @$el.html(@form.render().el)
      div = $('<div>', {class: 'rating-colors'}).insertAfter(@$('input[name=color]'))
      for color in @colors
        $('<div>', 'data-color': color, style: "background: #{color}", class: 'rating-color').appendTo(div)
      @changeColor()


    fillColor: (e)->
      @$('input[name=color]').val($(e.currentTarget).data('color'))
      @changeColor()

    changeColor: (e) ->
      color = @$('input[name=color]').val()
      @$('input[name=color]').css({'background-color': color, color: inverse(color)})


