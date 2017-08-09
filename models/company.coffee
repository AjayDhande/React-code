define ['backbone'], (Backbone) ->
  class CompanyModel extends Backbone.Model
    url: '/company'

    parse: (response) ->
      response.company
