define ['jquery', 'underscore', 'backbone',
        'views/import/row'], ($, _, Backbone, ImportRowView) ->
  class CompareImportView extends Backbone.View
    el: '#compare'
    rows: {}
    row: 0
    rowCount: 0
    events:
      'click .next': 'next'
      'click .prev': 'prev'

    initialize: ->
      @rowCount = parseInt(@$el.data('row-count'), 10)
      @collection.on('add', @addOne, @)
      @render

    addOne: (importRow) ->
      iid = parseInt(importRow.id, 10)
      @rows[iid] = new ImportRowView(model: importRow)
      if iid == @row
        @render()

    next: (e)->
      e.preventDefault()
      if @row < (@rowCount - 1)
        @row++
        @render()

    prev: (e)->
      e.preventDefault()
      if @row > 0
        @row--
        @render()

    render: ->
      if @row of @rows
        @$('.content').html(@rows[@row].render())
      else
        @collection.getRow(@row)
