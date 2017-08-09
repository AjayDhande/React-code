define ['backbone',
    'collections/scopes/profile_scope',
    'views/scopes/list',
    'templates/time_off/buckets',
    'templates/time_off/bucket'], (Backbone,
    ProfileScopeCollection,
    ScopeListView,
    bucketsTemplate, bucketTemplate) ->
  class BucketView extends Backbone.View
    tagName: 'tr'
    initialize: ->
      @plans = @options.plans

    render: ->
      @$el.html(bucketTemplate(plans: @plans.models, model: @model))
      @


  class BucketsView extends Backbone.View
    events:
      'click th input[type="checkbox"]': 'checkAll'
      'change td input[type="checkbox"]': 'handleChange'
      'change select.assign-plan': 'handlePlanChange'
      'click .save': 'save'

    initialize: ->
      @collection.on('reset', @render, @)
      @scopes = new ProfileScopeCollection()
      @scopes.on 'add remove', @reload, @

    checkAll: (e) ->
      @$('tbody :checkbox').prop('checked', e.currentTarget.checked)

    handleChange: (e) ->
      @$('th :checkbox').prop('checked', false)
      @$('.save').text("Save (#{ @$('tbody :checked').length })")

    handlePlanChange: (e) ->
      @$('button.save').removeAttr('disabled')

    reload: ->
      @collection.setScopes(@scopes)
      @collection.fetch(reset: true)

    save: (e) ->
      e.preventDefault()
      bucketIds = _.map @$('tbody :checked'), (element) ->
          parseInt($(element).data('bucket-id'))

      planId = parseInt(@$('.assign-plan').val())
      _.map bucketIds, (bucketId) =>
        @collection.get(bucketId).set('plan_id', planId)

      @collection.saveAll()
      @collection.fetch(reset: true)

    render: ->
      @$el.html(
        bucketsTemplate(
          count: @collection.length,
          plans: @options.plans.models)
      )

      @$('.scope').html(new ScopeListView(collection: @scopes).render().el)
      @$buckets = @$('.buckets')
      @collection.each (bucket) =>
        @$buckets.append(
          new BucketView(
            model: bucket,
            plans: @options.plans
          ).render().el
        )

