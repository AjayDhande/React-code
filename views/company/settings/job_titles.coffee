define ['jquery', 'backbone', 'overlay'], ($, Backbone, OVLY) ->

  @app = {}
  @$el = undefined
  @$tiers = $("form.new_job_title select")
  @$newJobTitle = $("#new_job_title")
  @$list = $("#job-title-list")
  @url = "/company/settings/job-titles/update-order"
  @append = "job_title_"
  @fields_selector = ".fields"
  @text_selector = ".text"

  JOB_TITLES = ->
    # Public functions
    # privates
    init = ->
      $list.sortable
        axis: "y"
        opacity: .6
        forceHelperSize: true
        stop: onOrder

      $list.on('click', 'a.delete', confirmDestroy)
      $list.on('click', 'a.edit', onEdit)
      $list.on('ajax:success', '.edit_job_title', onEditComplete)
      $newJobTitle.on "ajax:success", onNew
      $tiers.change (e) ->
        val = $(e.currentTarget).val()
        handleChange val

    confirmDestroy = (e) ->
      e.preventDefault()
      OVLY.showURL $(e.currentTarget).attr("href"), 400, 400

    onEdit = (e) ->
      e.preventDefault()
      $el = $(e.currentTarget).closest("form")
      $el.find(text_selector).hide()
      $el.find(fields_selector).show()
      $sel = $el.find("select")
      kids = $tiers.children().clone()
      if $sel.length > 0
        val = $el.find("#hidden_parent_id").val()
        $sel.children().remove()
        kids = kids.splice(1)
        #console.log($sel, kids, val);
        $sel.append(kids).val(val)
      $el.show()

    handleChange = (value) ->
      if value
        $("#new_job_title button").text "Add Job Title"
      else
        $("#new_job_title button").text "Add Tier"

    onEditComplete = (e, r, status, xhr) ->
      if r.success
        $el = $(e.target)
        if r.parent_id isnt null
          $parent = $el.parent().parent().parent()
          parentId = parseInt($parent.attr("id").split(append).join(""), 10)
          if parentId isnt r.parent_id
            $("#" + append + r.parent_id + " ul").append $el.parent()
            $el.find("#hidden_parent_id").val r.parent_id
        $el.find(fields_selector).hide()
        $el.find(text_selector).show().find(".title").html r.title
      else
        alert r.msg

    onNew = (e, r, status, xhr) ->
      if r.success
        jobTitle = "<li id=\"" + append + r.id + "\">" + r.form + "</li>"
        $el = $(e.target)
        $el.find("input[type=text]").val ""
        if r.parent_id is null
          kids = $tiers.children().clone()
          $tiers.children().remove()
          $list.append jobTitle
          $tiers.append(kids).append("<option value=\"" + r.id + "\">" + r.title + "</option>")
        else
          $("#" + append + r.parent_id + " ul").append jobTitle
      else
        alert r.msg

    onOrder = (e, ui) ->
      $.ajax(
        url: url
        data: ui.item.parent().sortable("serialize")
      ).success onOrderUpdate
    
    onOrderUpdate = (r) ->


    app.onJobTitleMoveTier = (id, tier_id) ->
      OVLY.hide()
      $el = $("#" + append + id)
      $tier = $("#" + append + tier_id)
      $el.appendTo $tier.find("ul")

    app.onJobTitleDelete = (id, orphanage_id) ->
      OVLY.hide()
      $el = $("#" + append + id)
      if orphanage_id
        $children = $el.find("ul").html()
        $orphanage = $("#" + append + orphanage_id)
        $orphanage.find("ul").append $children
      $el.delay(500).fadeTo 500, 0, ->
        $el.remove()

      $list.sortable "refresh"
      tier = $tiers.find("option[value=\"" + id + "\"]")
      if tier
        tier.remove()
        $tiers.change (e) ->
          val = $(e.currentTarget).val()
          handleChange(val)

    init()
    app

  class JobTitlesView extends Backbone.View
    initialize: ->
      @app = JOB_TITLES()


