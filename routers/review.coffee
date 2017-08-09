define ['jquery', 'backbone', 'utils',
        'models/review'
        'collections/review',
        'collections/performance/pending_task',
        'views/performance/pending_tasks/index',
        'views/performance/reviews/me',
        'views/performance/reviews/written',
        'views/performance/reviews/their',
        'views/performance/reviews/all',
        'views/performance/reviews/show',
        'views/performance/reviews/create',
        'views/performance/reviews/edit',
        'views/performance/review_batchers/edit',
        'views/performance/review_batchers/index',
        'views/performance/review_batchers/manager_assign',
        'models/review_batcher',
        'models/review_batcher_reviewee'
        'collections/review_batcher_reviewee',
        'collections/review_batcher_reviewee_peer',
        'views/performance/review_group_options',
        'jquery.tablesorter'], ($, Backbone, Utils,
        ReviewModel,
        ReviewCollection,
        PendingTaskCollection,
        ReviewPendingTasksIndexView,
        ReviewsMeView,
        ReviewsWrittenView,
        ReviewsTheirView,
        ReviewsAllView,
        ReviewShowView,
        ReviewCreateView,
        ReviewEditView,
        ReviewBatcherEditView,
        ReviewBatcherIndexView,
        ReviewBatcherManagerAssignView,
        ReviewBatcherModel,
        ReviewBatcherRevieweeModel,
        ReviewBatcherRevieweeCollection,
        ReviewBatcherRevieweePeerCollection,
        ReviewGroupOptionsView) ->
  class ReviewRouter extends Backbone.SubRoute
    routes:
      'review_batchers/:batcher_id/reviewees/:id/manager_assign' : 'reviewBatcherManagerAssign'
      'review_batchers/:id/edit' : 'reviewBatcherEdit'
      'review_batchers/:id' : 'reviewBatcherShow'
      'review_batchers' : 'reviewBatcherIndex'
      'reviews/new' : 'reviewCreate'
      'reviews/me' : 'reviewsMe'
      'reviews/written' : 'reviewsWritten'
      'reviews/their' : 'reviewsTheir'
      'reviews/all' : 'reviewsAll'
      'reviews/:id' : 'reviewShow'
      'reviews/:id/print' : 'reviewPrint'
      'reviews/:review_id/reviewers/:reviewer_id/edit' : 'reviewEdit'
      'pending' : 'pendingTasks'

    reviewShow: (id)->
      model = new ReviewModel(id: id)
      model.fetch(success: (response)=>
        new ReviewShowView(model: model)
      )

    reviewCreate: ->
      new ReviewCreateView

    reviewsMe: ->
      collection = new ReviewCollection
      collection.url = "/performance/reviews/search?reviewee=true"
      collection.fetch(success: (response) => new ReviewsMeView(collection: collection))

    reviewsWritten: ->
      collection = new ReviewCollection
      collection.url = "/performance/reviews/search?reviewer=true"
      collection.fetch(success: (response) => new ReviewsWrittenView(collection: collection))

    reviewsTheir: ->
      collection = new ReviewCollection
      collection.url = "/performance/reviews/search?report_to=true"
      collection.fetch(success: (response) => new ReviewsTheirView(collection: collection))

    reviewsAll: ->
      collection = new ReviewCollection
      collection.url = "/performance/reviews/search?all=true"
      collection.fetch(success: (response) => new ReviewsAllView(collection: collection))

    reviewEdit: (review_id, reviewer_id)->
      model = new ReviewModel(id: review_id)
      model.fetch(data:{reviewer_id: reviewer_id}, success: (response)=>
        new ReviewEditView(model: model))

    reviewBatcherShow: ->
      new ReviewGroupOptionsView

    reviewBatcherIndex: ->
      new ReviewBatcherIndexView()

    pendingTasks: ->
      collection = new PendingTaskCollection()
      collection.fetch success: =>
        new ReviewPendingTasksIndexView(collection: collection).render()

    reviewPrint: ->
      $(window.print)

    reviewBatcherEdit: (id) ->
      model = new ReviewBatcherModel(id: id)
      reviewees = new ReviewBatcherRevieweeCollection(model:model)
      new ReviewBatcherEditView(reviewees: reviewees)

    reviewBatcherManagerAssign: (batcher_id, id) ->
      model = new ReviewBatcherRevieweeModel(batch_id: batcher_id, id: id)
      assigned_peers = new ReviewBatcherRevieweePeerCollection(model:model, is_nominating: false)
      new ReviewBatcherManagerAssignView(assigned_peers: assigned_peers)
