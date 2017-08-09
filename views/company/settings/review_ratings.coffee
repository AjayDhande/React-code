define ['jquery', 'underscore', 'backbone', 'overlay'], ($, _, Backbone, OVLY) ->
  REVIEW_RATINGS = ->
    # Public functions
    # privates
    init = ->
      $list.sortable
        axis: "y"
        opacity: .6
        forceHelperSize: true
        stop: onOrder

      $list.on('click', "a.delete", confirmDestroy)
      $list.on('click', "a.edit", onEdit)
      $list.on('ajax:success', ".edit-form", onEditComplete)
      $list.on('click', ".cancel", closeEditField)
      $newReviewRating.on "ajax:success", onNew

    confirmDestroy = (e) ->
      e.preventDefault()
      OVLY.showURL $(e.currentTarget).attr("href"), 400, 300

    onEdit = (e) ->
      e.preventDefault()
      $el = $(e.currentTarget).parents("form")
      closeEditingArea $currentEditingArea  if $currentEditingArea
      $currentEditingArea = $el
      $el.find(text_selector).hide()
      $el.find(fields_selector).show()
      $list.sortable "disable"
      $el.show()

    onEditComplete = (e, r, status, xhr) ->
      if r.success
        $el = $(e.target)
        $el.find(fields_selector).hide()
        $el.find(text_selector).show().find(".title").html r.title
        $el.find(".colorPicker").empty()
      else
        alert r.msg

    closeEditField = (e) ->
      e.preventDefault()
      $el = $(e.target).parents("form")
      closeEditingArea $el
      $list.sortable "enable"
      $currentEditingArea = null

    closeEditingArea = ($target) ->
      $target.find(text_selector).show()
      $target.find(fields_selector).hide()
      $target.find(".colorPicker").empty()

    colorPickerClick = (e) ->
      $target = $(e.target)
      colorHex = $target.val() or "#ffffff"
      $colorPicker = $target.siblings(".colorPicker")
      $colorPicker.empty()

    onNew = (e, r, status, xhr) ->
      if r.success
        reviewRating = "<li id=\"" + append + r.id + "\">" + r.form + "</li>"
        $el = $(e.target)
        $el.find("input[type=text]").val ""
        $list.prepend reviewRating
        onOrder()
      else
        alert r.msg

    onOrder = ->
      $.ajax(
        url: orderUrl
        data: $list.sortable("serialize")
      ).success onOrderUpdate

    onOrderUpdate = (r) ->
    app = {}
    $el = undefined
    $newReviewRating = $("#new_performance_review_rating")
    $color_picker = $(".color_picker")
    $list = $("#review-ratings-list")
    append = "review-rating_"
    orderUrl = "/company/settings/review-ratings/update-order"
    fields_selector = ".fields"
    text_selector = ".text"
    selectOpts =
      classHolder: "sb-holder"
      classOptions: "sb-options"

    $currentEditingArea = null

    app.onReviewRatingDelete = (id) ->
      OVLY.hide()
      el = $("#" + append + id)
      el.delay(500).fadeTo 500, 0, ->
        el.remove()
        onOrder()

      $list.sortable "refresh"

    init()
    app

  class ReviewRatingsView extends Backbone.View
    initialize: ->
      @app = REVIEW_RATINGS()
