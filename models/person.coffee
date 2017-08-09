define ['backbone'], (Backbone) ->
  class PersonModel extends Backbone.Model
    defaults:
      inactive: false

    url: ->
      "/people/#{@id}"

    indexText: ->
      @_indexText ?= "#{@get('full_name')} #{@get('job_title')} #{@get('office_city')}".toLowerCase()

    match: (value) ->
      @indexText().indexOf(value) >= 0

    children: ->
      @collection.childrenOf(@)

    ancestors: ->
      @collection.ancestorsOf(@)

    parent: ->
      @collection.get(@get('parent_id'))

    level: (levelCache=0) ->
      if @isRoot() || !@parent()
        levelCache
      else
        @parent().level(levelCache + 1)

    isRoot: ->
      !@get('parent_id')? || !@collection.get(@get('parent_id'))?

    profileUrl: ->
      "/people/#{ @id} "

    toString: ->
      @get('full_name')

