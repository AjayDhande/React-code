define ['jquery', 'underscore', 'backbone', 
        'models/skilltag', 'views/skilltag/skilltag'], ($, _, Backbone, 
        SkillTagModel, SkillTagView) ->

  class SkillTagFormView extends Backbone.View
    el: '#skill_tag_edit_form'

    events:
      'click .save': 'save'

    initialize: ->
      @tagDisplay = $('#skill_tag_edit_display')
      @collection.each (skillTag) =>
        @addSkillTag skillTag

    save: (e) ->
      e.preventDefault()
      if (NamelyUsersCreateSkillTags)
        title = $("#skill_tag").val()
      else
        title = $("#skill_select").val()
      if (!title)
        return
      model = new SkillTagModel title: title, notes: ''
      @addSkillTag model
      $("#skill_tag").val ''

    addSkillTag: (skillTag) ->
      new SkillTagView({model: skillTag, container: @tagDisplay})

