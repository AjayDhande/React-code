define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class ReportsNewView extends Backbone.View
    el: '.reports'
    events:
      'click .type a': 'toggleReportType'
      'click .type a': 'toggleReportType'
      'keyup #report_title': 'checkTitlePresence'
      'keyup #default-title' : 'syncTemplateTitle'

    initialize: ->
      @syncTemplateTitle()
      @examples = $('.examples > div')
      $(".type#canned .create-report").attr("disabled", "disabled")

    syncTemplateTitle: ->
      $('#canned-title').val($('#default-title').val())
    toggleReportType: (e) ->
      $target = $(e.target)

      $('.reports.new-form a').removeClass('current')
      $target.parent().parent().find('input#report_type').val($target.attr('id'))
      $target.addClass('current')
      @toggleExamples($target.attr('id'))
      $(".reports.new-form").find(".create-report").attr("disabled", "disabled")
      $target.parent().parent().find(".create-report").removeAttr("disabled")


    toggleExamples: (id) ->
      @examples.hide()
      _.find(@examples, (example) => 
        example.getAttribute('id') == id
      ).style.display = 'block'

    checkTitlePresence: (e) ->
      target = $(e.target)
      disabled = target.val().trim().length == 0
      $('.create-report').prop('disabled', disabled)
