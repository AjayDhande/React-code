define ['jquery', 'underscore', 'backbone',
        'collections/category',
        'views/components/editable_item',
        'views/components/confirm_destroy',
        'templates/categories/new', 'templates/categories/show' ], ($, _, Backbone,
        CategoryCollection,
        EditableItemView,
        ConfirmDestroyView,
        newCategoryTemplate, showCategoryTemplate) ->
  class DivisionsView extends Backbone.View
    events:
      'click .new-item': 'onNewItem'
      'click .new-category': 'addNewCategory'
      'click .create-category': 'saveNewCategory'
      'click .add-division-cancel': 'cancelNewCategory'
      'click a.edit-category' : 'toggleEdit'
      'click .update-category' : 'toggleSubmit'
      'click a.delete-category' : 'deleteCategory'

    itemMapping: {}
    itemView: EditableItemView

    initialize: (options)->
      @$items = $('#categories')
      @collection.on('add', @addItem, @)
      @collection.on 'reset', @resetDivisions, @
      @itemView = options.itemView if options.itemView
      @categoryCollection = new CategoryCollection
      @categoryCollection.on 'add', @addCategory, @
      @categoryCollection.on 'reset', @resetCategories, @

      @categoryCollection.fetch reset: true
      @collection.fetch reset: true

    toggleEdit: (e) ->
      id = $(e.currentTarget).attr('category')
      category = @categoryCollection.get(id)
      $(".show-category[category=#{id}]").toggle()
      $(".edit-category[category=#{id}]").toggle()
      $("input.title[category=#{id}]").val(category.get("title"))

    toggleSubmit: (e) ->
      id = $(e.currentTarget).attr('category')
      category = @categoryCollection.get(id)
      $(".edit-category[category=#{id}]").toggle()
      $(".show-category[category=#{id}]").toggle()
      category.set('title', $("input.title[category=#{id}]").val())
      category.set('page_available', $("input.page-available[category=#{id}]").is(":checked"))
      $("h3.category-title[category=#{id}]").text(category.get("title"))
      category.save()

    deleteCategory: (e) ->
      id = $(e.currentTarget).attr('category')
      category = @categoryCollection.get(id)
      new ConfirmDestroyView(model: category).render()
      category.on 'destroy', =>
        @$(".category-block[category=#{category.id}]").remove()
        @categoryCollection.remove(category)

    resetCategories: ->
      @categoriesLoaded = true
      if @divisionsLoaded
        @render()

    resetDivisions: ->
      @divisionsLoaded = true
      if @categoriesLoaded
        @render()

    render: ->
      @$items.find(".items").empty()
      @categoryCollection.each((category) => @$items.append showCategoryTemplate(category: category))
      @collection.each((model) => @addItem(model))

    onNewItem: (e) ->
      e.preventDefault()
      category_id = $(e.target).attr('category')
      model = new @collection.model()
      model.set("category_id", category_id)
      model.set("company_category_id", category_id)
      @collection.add(model, silent: true)
      @addItem(model)

    addItem: (model) ->
      new @itemView(
        el: @addBlankItem(model)
        model: model
      ).render()

    addBlankItem:(model) ->
      category_id = model.get("category_id")
      $('<li>', class: 'item').appendTo(@$items.find(".items[category=#{category_id}]"))

    addNewCategory: (e)->
      e.preventDefault()

      if !@$newCategoryForm?
        @$newCategoryForm = $(newCategoryTemplate())
        @$items.prepend @$newCategoryForm

    cancelNewCategory: (e)->
      e.preventDefault()
      @removeNewCategoryForm()

    removeNewCategoryForm: ->
      @$newCategoryForm.remove()
      @$newCategoryForm = null

    saveNewCategory: (e) ->
      e.preventDefault()
      params = {title: @$('input.category-title').val(), page_available: @$('input.page-available').is(":checked")}
      newCategory = @categoryCollection.create(params, {wait: true})
      @removeNewCategoryForm()
      @

    addCategory: (category) ->
      @$items.prepend showCategoryTemplate(category: category)
