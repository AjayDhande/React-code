define ['backbone.relational',
        'models/workflows/category',
        'models/workflows/event'], (BackboneRelational,
        WorkflowCategoryModel,
        WorkflowEventModel) ->
  class WorkflowModel extends Backbone.RelationalModel
    url: -> "/workflows/#{@id}"
    idAttribute: 'id'
    relations: [{
      type: Backbone.HasMany,
      key: 'categories',
      relatedModel: WorkflowCategoryModel,
      reverseRelation: {
        key: 'workflow',
        includeInJson: 'id'
      }
    },{
      type: Backbone.HasMany,
      key: 'events',
      relatedModel: WorkflowEventModel,
      reverseRelation: {
        key: 'workflow',
        includeInJson: 'id'
      }
    }]

    copy: (attributes, callback) ->
      data = {'id': @get('id'), 'title': attributes['title']}
      $.post(@url() + '/copy', data).done(callback)

    kickoff: (attributes, sendmail, callback) ->
      status = attributes['status']
      data = {'id': @get('id'), 'status': status, 'sendmail': sendmail}
      @set('status': status)
      $.post(@url() + '/kickoff', data).done(callback)

    addParticipant: (participant, callback) ->
      $.post(@url() + '/participants', participant).done(callback)

    removeParticipant: (participant) ->
      $.ajax({url: @url() + '/participants/' + participant.participant_id, type: 'DELETE'})

    remindParticipant: (id, callback) ->
      $.post("#{@url()}/participants/#{id}/remind").done(callback)

    updateFolder: (data, callback) ->
      $.ajax({url: @url(), type: 'PUT', contentType: 'application/json', dataType: 'json', data: data}).done(callback)

    updateOrder: (url, items) ->
      $.ajax({url: url, data: items})
