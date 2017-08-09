define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class AccessRolesIndexView extends Backbone.View
    el: '#content .content-holder'

    events:
      'click .delete': 'confirmDestroy'
      'click .edit': 'onEdit'
      'click .clone': 'clone'
      'ajax:success .edit_access_role': 'onEditComplete'
      'ajax:success #new_access_role': 'onNew'

    $newAccessRole: $('#new_access_role')
    $list: $('#access_roles')
    append: 'access_role_'
    fields_selector: '.fields'
    text_selector: '.text'
    order_url: '/company/settings/access-roles/update-order/'

    initialize: ->
      @$list.sortable
        axis:'y'
        opacity:.6
        forceHelperSize:true
        stop:@onOrder


    onOrder: (e, ui) =>
      $.ajax
        url:@order_url
        data:ui.item.parent().sortable('serialize')

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

    clone: (e) ->
      $.ajax
        url: '/company/settings/access-roles'
        data:
          clone: true
          id: $(e.currentTarget).data('id')
        success: _.bind(@onClone, @)

      e.preventDefault()


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

    onClone: (r, status, xhr) ->
      if r.success
        @appendNewItem(r)
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

    appendNewItem: (r) ->
      accessRole = '<li id="' + @append + r.id + '">' + r.form + '</li>'
      @$list.append(accessRole)

    setDefault: (id) ->
      $("#edit_access_role_#{id}").find('.is_default').addClass('show')
