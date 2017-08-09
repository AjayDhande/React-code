define ['jquery', 'underscore', 'backbone',
        'models/country',
        'templates/components/subdivisions'], ($, _, Backbone, CountryModel, subdivisionTemplate) ->
  class CountrySubdivisionView extends Backbone.View
    template: subdivisionTemplate
    events:
      'change select.country': 'select'

    initialize: ->
      @$countrySelect = @$('select.country')
      @$subdivisionSelect = @$('select.subdivisions')
      @$subdivisionLabel = @$('label.subdivisions')
      @checkSubdivisionShow()

    select: ->
      if selected = @$countrySelect.val()
        @model = new CountryModel(id: selected)
      @render()

    checkSubdivisionShow: ->
      if @$countrySelect.val()
        @$subdivisionLabel.show()
        @$subdivisionSelect.show()
      else
        @$subdivisionLabel.hide()
        @$subdivisionSelect.hide()

    render: ->
      if @model
        subdivisions = @model.subdivisions()

        renderTemplate = =>
          $select = @$subdivisionSelect
          if subdivisions.length
            $select.html(@template(subdivisions: subdivisions.toJSON())).val('')
            if $select.data('auto-value')
              $select.val($select.data('auto-value'))
          else
            $select.empty().val('')

        @checkSubdivisionShow()

        if subdivisions.length > 1
          renderTemplate()
        else
          subdivisions.fetch
            success: =>
              renderTemplate()
