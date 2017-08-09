define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class AccessFieldGroupBundlesIndexView extends Backbone.View
    el: '#content .content-holder'

    events:
      'click .delete': 'confirmDestroy'
      'click .edit': 'onEdit'
      'ajax:success .edit_access_field_group_bundle': 'onEditComplete'
      'ajax:success #new_access_field_group_bundle': 'onNew'

    $newAccessRole: $('#new_bundle')
    $list: $('#bundles')
    append: 'bundle_'
    fields_selector: '.fields'
    text_selector: '.text'

    onEdit: (e) ->
      e.preventDefault()
      $el = $(e.currentTarget).closest('form')
      $el.find(@text_selector).hide()
      $el.find(@fields_selector).show()
      $el.show()

    onDelete: (id) ->
      OVLY.hide()
      target = $('#' + @append + id)
      target.delay(500).fadeTo(500, 0, => target.remove() )

    confirmDestroy: (e) ->
      e.preventDefault()
      OVLY.showURL($(e.currentTarget).attr('href'), 400, 300)

    onEditComplete: (e, r, status, xhr) -> 
      if r.success
        $el = $(e.target)
        $el.find(@fields_selector).hide()
        $el.find(@text_selector).show().find('.title').html(r.title)
      else
        alert(r.msg)

    onNew: (e, r, status, xhr) ->
      if r.success
        accessRole = '<li id="' + @append + r.id + '">' + r.form + '</li>'
        $el = $(e.target)
        $el.find('input[type=text]').val('')
        @$list.append(accessRole)
      else
        alert(r.msg)
