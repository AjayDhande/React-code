define ['jquery', 'underscore', 'backbone',
    'models/time_off/modifier',
    'views/scopes/list',
    'templates/time_off/modifier'], ($, _, Backbone,
    ModifierModel, ScopeListView, template) ->
  class ModifierView extends Backbone.View
    className: 'modifier-container'
    events:
      'change input': 'change'
      'click .delete-modifier': 'delete'
      'click .revert-modifier': 'revert'

    render: ->
      @$el.html(template(model: @model))
      new ScopeListView(
        el: @$('.qualifiers')
        collection: @model.get('profile_scopes')
      ).render()
      @

    change: (e) ->
      $el = $(e.currentTarget)
      name = $el.attr('name')
      if matches = name.match(/modifier\[(\w+)\]/i)
        @model.set(matches[1], $el.val())

    delete: (e) ->
      @model.set('_destroy', true)
      @$('.modifier').addClass('hidden')
      @$('.modifier').parent().addClass('hidden-child')
      @$('.modifier-revert').removeClass('hidden')
      @trigger('delete')

    revert: (e) ->
      @model.set('_destroy', false)
      @$('.modifier').removeClass('hidden')
      @$('.modifier-revert').addClass('hidden')
