define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  # Uses a timer for the scroll event to reduce overhead for slower machines.
  # If the fixed sidebar is responding too slowly, simply change speed.
  $.fn.scrolled = (fn) ->
    speed = 10
    tag = "scrollTimer"
    this.scroll ->
      self = $(this)
      timer = self.data(tag)
      if (timer)
        clearTimeout(timer)
      tf = ->
        self.data(tag, null)
        fn()
      timer = setTimeout(tf, speed)
      self.data(tag, timer)

  class ReviewEditView extends Backbone.View
    fixSidebar = ->
      y = $(window).scrollTop()
      bottom = $(document).height() - $('#review_sidebar').outerHeight() - parseInt($('#content').css('padding-bottom'), 10) - 50
      if y > 317 && y <= bottom
        $('#review_sidebar').css
          'position': 'fixed'
          'top': '25px'
          'bottom': 'auto'
          'right': '50%'
          'margin-right': '-467px'
      else if y <= 317
        $('#review_sidebar').css
          'position': 'absolute'
          'top': '242px'
          'bottom': 'auto'
          'right': '25px'
          'margin-right': '0px'
      else if y > bottom
        $('#review_sidebar').addClass('bottom').css
          'position': 'absolute'
          'top': 'auto'
          'bottom': '15px'
          'right': '25px'
          'margin-right': '0px'

    bumpSidebar = ->
      $("html, body").animate
        scrollTop: $(document).scrollTop() - 70 + 'px'
      $('#review_sidebar').removeClass('bottom').css
        'position': 'absolute'
        'top': '242px'
        'bottom': 'auto'
        'right': '25px'
        'margin-right': '0px'

    toggleSlider: (e) ->
      target = $(e.target);
      slider = target.parent().parent().children('div.rating')

      if target.prop('checked')
        slider.slider('disable')
      else
        slider.slider('enable')

    initialize: (options)->
      @model = options.model
      $('#review_sidebar').fadeIn()
      $('input.na-checkbox').click(@toggleSlider)

      $('input[type=range]').each (index, element) =>
        $input = $(element)
        question_id = $input.data("question")
        question = @model.find_question(question_id)
        $slider = $('<div id="' + $input.attr('id') + '" class="' + $input.attr('class') + '"></div>')
        $display = $input.siblings('.display').find('span')
        if question["options"]["use_labels"]
          if question["options"]["only_use_labels"]
            $display.html(question["options"]["rating_labels"][Math.round($input.val())])
          else
            $display.html("#{$input.val()}: #{question['options']['rating_labels'][Math.round($input.val())]}")
        else
          $display.html($input.val())
        $input.after($slider).hide()
        $slider.slider
          range: 'min'
          min: Number($input.attr('min'))
          max: Number($input.attr('max'))
          step: Number($input.attr('step'))
          value: $input.attr('value')
          change: (e, ui) ->
            $input.attr('value', ui.value)
          slide: (e,ui) =>
            if question["options"]["use_labels"]
              if question["options"]["only_use_labels"]
                $display.html(question['options']['rating_labels'][Math.round(ui.value)])
              else
                $display.html("#{ui.value}: #{question['options']['rating_labels'][Math.round(ui.value)]}")
            else
              $display.html(ui.value)
        na = $input.parent().find('.na-checkbox')
        $slider.slider('disable') if na.prop('checked')

      if $(window).height() > $('#review_sidebar').outerHeight()
        fixSidebar()
        $(window).scrolled -> fixSidebar()
