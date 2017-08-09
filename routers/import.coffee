define ['backbone',
        'collections/import_row',
        'views/import/compare_import',
        'views/import/attach'], (Backbone,
        ImportRowCollection,
        CompareImportView,
        AttachView) ->
  class ImportRouter extends Backbone.SubRoute
    routes:
      ':id/review': 'review'
      ':id/columns': 'columns'

    review: (id) ->
      importRows = new ImportRowCollection([], {importId:id})
      new CompareImportView(collection: importRows)

    columns: (id) ->
      new AttachView attach_id :id

