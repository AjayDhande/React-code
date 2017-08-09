define ['jquery', 'underscore', 'backbone'], ($, _, Backbone, template) ->
  class ReviewGroupOptionsView extends Backbone.View
    events:
      "click input[type=radio]": "radioClicked"

    initialize: ->
      @$el = $("#review_group_options")

      @$("input[type=radio]").attr("checked",false)
      @$(".checked").removeClass("checked")

      $('#review_group_options_toggle').click =>
        @$el.toggle()

    radioClicked: (e) ->
      @$(".submit").show()
      target_type = $(e.target).val()
      @$(".group_type").hide()
      @$(".#{target_type}_group_type").show()
