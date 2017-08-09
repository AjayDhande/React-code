define ['backbone'], (Backbone) ->
  class AttachmentModel extends Backbone.Model

    url: ->
      if @isNew()
        return "/attachments"
      else
        return "/attachments/#{@get('id')}"

    idAttribute: 'id'

    removeAttachment: (attachment_id, callback) ->
      $.ajax({url: '/attachments/' + attachment_id, type: 'DELETE'}).done(callback)