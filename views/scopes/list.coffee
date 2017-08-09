define ['jquery', 'underscore', 'backbone',
    'views/scopes/form',
    'views/scopes/show',
    'templates/scopes/list'], ($, _, Backbone,
    ScopeFormView,
    ScopeView,
    template) ->
  class ScopeListView extends Backbone.View
    initialize: ->
      @selectLabel = @options.selectLabel || 'Add Filter'
      @addLabel = @options.addLabel || 'Apply'

    events:
      'click .scope-add': 'addNewScope'

    addNewScope: (e) ->
      e.preventDefault()
      scope = new @collection.model
      filter = new (scope.get('filters').model)
      scope.get('filters').add([filter])

      formView = new ScopeFormView(
          addLabel: @addLabel,
          fields: @options.fields,
          model: filter
        ).render()
      @$('.scope-form').html(formView.el)

      formView.on 'save', =>
        @collection.add([scope], add: true)
        formView.remove()
        @renderScope(scope)

    render: ->
      @$el.html(template(selectLabel: @selectLabel, collection: @collection))
      @$scopeList = @$('.scope-list')
      @collection.each (scope) => @renderScope(scope)
      @

    renderScope: (scope) ->
      @$scopeList.prepend(new ScopeView(model: scope).render().el)

    enable: ->
      @$('.scope-add, select.scope-field, select.scope-value, .create-criteria').removeAttr('disabled')
      @$('.scope-filter').removeClass('disabled')

    disable: ->
      @$('.scope-add, select.scope-field, select.scope-value, .create-criteria').attr('disabled', 'disabled')
      @$('.scope-filter').addClass('disabled')
