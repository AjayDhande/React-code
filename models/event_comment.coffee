define ['backbone', 'backbone.relational'], (Backbone) ->

  class EventCommentModel extends Backbone.RelationalModel

    defaults:
      content: ''

    urlRoot: ->
      parent = @get('parent') or @collection.parent
      "/events/#{ parent.id }/comments"
