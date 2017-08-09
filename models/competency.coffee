define ['backbone.relational', 'collections/competencies/competency'], (BackboneRelational) ->
  class CompetencyModel extends Backbone.RelationalModel
    idAttribute: 'id'
    url: ->
      set = @get('competency-set')
      category = set.get('category')
      if @isNew()
        return "/competency_categories/#{category.get('id')}/sets/#{set.get('id')}/competencies"
      else
        return "/competency_categories/#{category.get('id')}/sets/#{set.get('id')}/competencies/#{@id}"
