define ['backbone'], (Backbone) ->
  class PayGroupModel extends Backbone.Model
    schema:
      title: type: 'Text', validations: ['required']
      pay_period_name:      { type: 'Select', options: ['Daily', 'Weekly', 'Bi-Weekly', 'Semi-Monthly', 'Monthly', 'Quarterly', 'Semi-Annually', 'Annually'] }
    #orphans: (collection) ->
    #  new Backbone.Collection(collection.where({company_id: @get("company_id")}))