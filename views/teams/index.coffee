define ['jquery', 'underscore', 'backbone',
        'views/teams/search',
        'views/components/tooltip'], ($, _, Backbone,
        AccountSearchView,
        TooltipView) ->
  class AccountIndexView extends Backbone.View
    el: '#team-page'

    events:
      'click .category': 'selectCategory'
      'change #status-filter' : 'changeStatusFilter'

    initialize: ->
      @$teamList = $('#team-list')
      @$teamFilter = $('#teams-filter')
      @$categoryAllButton = $('#category-all')
      @changeStatusFilter()
      _.each(@$el.find('a.tooltip'), (link) => new TooltipView(el: $(link)))

      category = @$('.category:first')
      @selectCategoryWith(category)
      @colorCategoryButton(category)

    colorCategoryButton: (target) ->
      @$('a').removeClass('on')
      target.addClass('on')

    resetCategoryButton: ->
      @categoryFilter = @divisionFilter = @statusFilter = null
      @$teamFilter.find('a').removeClass('on')
      @colorCategoryButton(@$('#category-all'))

    changeStatusFilter: ->
      @statusFilter = @$('#status-filter').val()
      @filterAccounts()

    selectCategoryWith: (target) ->
      categoryString = target.attr("category")
      divisionString = target.attr("division")
      statusString = target.attr("status")
      if statusString == 'all'
        @resetCategoryButton()
      else
        @categoryFilter = categoryString || @categoryFilter
        @divisionFilter = divisionString || @divisionFilter
        unless target.hasClass('on')
          @colorCategoryButton target
          @$categoryAllButton.removeClass('on')
      @filterAccounts()

    selectCategory: (e) ->
      e.preventDefault()
      @selectCategoryWith($(e.target))

    filterCollectionById: (collection, id, type) ->
      collection.filter (index) ->
        item = collection[index]
        ids = $(item).data(type)
        _.contains(ids, id)

    filterAccounts: ->
      @$("#division-list-container").hide()
      @$(".division-category").hide()
      @$("#status-filter").css('visibility', 'visible')

      showCollection = @$teamList.find("li")
      if @statusFilter && @statusFilter != 'all'
        showCollection = showCollection.filter(".#{@statusFilter}")

      if @divisionFilter
        divisionId = parseInt(@divisionFilter)
        @$(".division-category[data-id=#{divisionId}]").show()
        showCollection = @filterCollectionById(showCollection, divisionId, 'division')
        @$("#status-filter").css('visibility', 'hidden')
        @$("#division-list-container").show()
        @divisionFilter = null

      if @categoryFilter
        categoryId = parseInt(@categoryFilter)
        showCollection = @filterCollectionById(showCollection, categoryId, 'category')

      @$teamList.find("li").hide()
      showCollection.show()
