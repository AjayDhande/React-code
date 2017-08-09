define ['backbone',
        'collections/field',
        'collections/section',
        'views/fields/sections'], (Backbone, FieldCollection, SectionCollection,
        SectionView) ->
  class FieldRouter extends Backbone.SubRoute
    routes:
      "": "fields"
    fields: ->
      fields = new FieldCollection()
      fields.fetch
        success: =>
          sections = new SectionCollection()
          sections.fetch
            success: ->
              view = new SectionView(collection: sections, fields: fields)
              view.render()
