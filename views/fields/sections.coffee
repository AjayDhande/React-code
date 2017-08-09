define ['jquery', 'underscore', 'backbone',
        'views/fields/section'], ($, _, Backbone, SectionView) ->
  class SectionsView extends Backbone.View
    el: '#section-admin'
    events:
      'click .save': 'save'

    initialize: (options) ->
      @fields = options.fields
      @$content = @$('.content')
      @sectionViews = @collection.map (section) =>
        new SectionView
          model: section
          fields: @fields

    save: (e) ->
      e.preventDefault()
      @fields.bulk_update()


    render: ->
      @$content.empty()
      _.each @sectionViews, (view) => @$content.append(view.render())
