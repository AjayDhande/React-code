define ['backbone',
        'collections/division',
        'collections/pay_group',
        'collections/office',
        'collections/skilltag',
        'collections/team_category',
        'collections/country',
        'collections/terminated_reason',
        'collections/review_rating',
        'collections/time_off/plan',
        'collections/holiday/plan',
        'collections/time_off/bucket',
        'collections/competencies/category',
        'collections/job_title',
        'views/components/editable_item_list',
        'views/company/settings/office_editable_item',
        'views/company/settings/review_rating_editable_item',
        'views/company/settings/review_rating_editable_item_list',
        'views/company/settings/companies',
        'views/company/settings/competencies',
        'views/company/settings/access_field_group_bundles_index',
        'views/company/settings/access_field_group_bundles_grid',
        'views/company/settings/access_roles_index',
        'views/company/settings/access_roles_show',
        'views/company/settings/job_titles',
        'views/company/settings/review_ratings',
        'views/company/settings/divisions',
        'views/company/settings/notifications',
        'views/company/settings/pay_groups',
        'views/company/settings/time_off/plans',
        'views/company/settings/holiday/plans',
        'views/company/settings/time_off/buckets',
        'backbone-forms-pure'], (Backbone,
        DivisionCollection,
        PayGroupCollection,
        OfficeCollection,
        SkillTagCollection,
        TeamCategoryCollection,
        CountryCollection,
        TerminatedReasonCollection,
        ReviewRatingCollection,
        TimeOffPlanCollection,
        HolidayPlanCollection,
        TimeOffBucketCollection,
        CompetencyCategoryCollection,
        JobTitleCollection,
        EditableItemListView,
        OfficeEditableItemView,
        ReviewRatingEditableItemView,
        ReviewRatingEditableItemListView,
        CompaniesView,
        CompetenciesView,
        AccessFieldGroupBundlesIndexView,
        AccessFieldGroupBundlesGridView,
        AccessRolesIndexView,
        AccessRolesShowView,
        JobTitlesView,
        ReviewRatingsView,
        DivisionsView,
        NotificationsView,
        PayGroupsView,
        TimeOffPlansView,
        HolidayPlansView,
        TimeOffBucketsView) ->
  class CompanySettingsRouter extends Backbone.SubRoute

    routes:
      "time_off/plans": "timeOffPlans"
      "holiday/plans": "holidayPlans"
      "time_off/types/:type_id/buckets": "timeOffBuckets"
      "field-group-bundles/grid": "accessFieldGroupBundlesGrid"
      "field-group-bundles": "accessFieldGroupBundlesIndex"
      "access-roles/:id": "accessRolesShow"
      "access-roles": "accessRolesIndex"
      "offices": "offices"
      "divisions": "divisions"
      "pay_groups" : "payGroups"
      "terminated_reasons": "terminatedReasons"
      "team_categories": "teamCategories"
      "companies": "companies"
      "competencies": "competencies"
      "skill_tags": "skillTags"
      "job-titles": "jobTitles"
      "review_ratings": "reviewRatings"
      "notifications": "notifications"

    accessFieldGroupBundlesIndex: ->
      Namely.accessFieldGroupBundlesIndex = new AccessFieldGroupBundlesIndexView

    accessFieldGroupBundlesGrid: ->
      new AccessFieldGroupBundlesGridView

    accessRolesIndex: ->
      Namely.accessRolesIndex = new AccessRolesIndexView()

    accessRolesShow: ->
      new AccessRolesShowView()

    companies: ->
      new CompaniesView()

    competencies: ->
      categories = new CompetencyCategoryCollection()
      categories.fetch success: =>
        new CompetenciesView(collection: categories)

    offices: ->
      Namely.countries = new CountryCollection()
      Namely.countries.fetch()

      offices = new OfficeCollection()
      offices.fetch success: =>
        new EditableItemListView
          el: '#offices'
          collection: offices
          autoRender: true
          itemView: OfficeEditableItemView

    divisions: ->
      new DivisionsView
        el: '#divisions'
        collection: new DivisionCollection()
        autoRender: true

    terminatedReasons: ->
      terminatedReasons = new TerminatedReasonCollection()
      terminatedReasons.fetch success: =>
        new EditableItemListView
          el: '#terminated-reasons'
          collection: terminatedReasons
          autoRender: true

    teamCategories: ->
      teamCategories = new TeamCategoryCollection()
      teamCategories.fetch success: =>
        new EditableItemListView
          el: '#team-categories'
          collection: teamCategories
          autoRender: true

    skillTags: ->
      skillTags = new SkillTagCollection()
      skillTags.fetch success: =>
        new EditableItemListView
          el: '#skill-tags'
          collection: skillTags
          autoRender: true

    notifications: ->
      new NotificationsView
        el: '#notification_settings'

    jobTitles: ->
      Namely.JobTitlesView = new JobTitlesView()

    reviewRatings: ->
      reviewRatings = new ReviewRatingCollection()
      reviewRatings.fetch success: =>
        new ReviewRatingEditableItemListView
          el: '#review-ratings'
          collection: reviewRatings
          autoRender: true
          itemView: ReviewRatingEditableItemView

    payGroups: ->
      payGroups = new PayGroupCollection()
      payGroups.fetch success: =>
        new EditableItemListView
          el: '#pay-groups'
          collection: payGroups
          autoRender: true

    timeOffPlans: ->
      timeOffPlans = new TimeOffPlanCollection()
      timeOffPlans.fetch(reset: true)
      new TimeOffPlansView(collection: timeOffPlans, el: '#time-off-admin')

    holidayPlans: ->
      holidayPlans = new HolidayPlanCollection()
      holidayPlans.fetch(reset: true)
      new HolidayPlansView(collection: holidayPlans, el: '#holiday-admin')

    timeOffBuckets: (typeId) ->
      typeId = parseInt(typeId)
      plans = new TimeOffPlanCollection()
      plans.fetch(reset: true, success: =>
        type = plans.types.findWhere(id: typeId)
        plans = new TimeOffPlanCollection(plans.where(type_id: typeId))
        buckets = new TimeOffBucketCollection(type: type)
        buckets.fetch(reset: true)
        new TimeOffBucketsView(
          collection: buckets,
          type: type,
          plans: plans,
          el: '#time-off-admin')
      )
