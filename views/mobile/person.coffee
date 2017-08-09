define ['jquery', 'backbone', 'mobile_utils',
        'models/person',
        'templates/mobile/person'], ($, Backbone, MobileUtils,
        PersonModel, personTemplate) ->
  class PersonView extends Backbone.View
    container: '#details'
    template: personTemplate

    events:
      'click #details-favs': 'toggleFavorite'
      'click #details-small-image': 'showLargeImage'
      'click #big-photo-close': 'hideLargeImage'
      'click #details-large-image-float': 'hideLargeImage'

    toggleFavorite: (e) ->
      e.preventDefault()
      if Namely.favorites.get(@model.id)
        Namely.favorites.removePerson(@model)
        @render(false)
      else
        Namely.favorites.addPerson(@model)
        @render(true)

    showLargeImage: (e) ->
      e.preventDefault()
      @$('#details-large-image-float').show()

    hideLargeImage: (e) ->
      e.preventDefault()
      @$('#details-large-image-float').hide()

    initialize: ->
      $(@container).empty().append(@$el)
      if Namely.people?
        @model = Namely.people.get(@options.personId)
        if @model
          @model.fetch success: =>
            @render()
          @render()
          return @

      @model = new PersonModel(id: @options.personId)
      @model.fetch success: =>
        @render()
      @

    focus: ->
      @options.headerView.setTitle('', '', true)

      

    render: (favorite) ->
      personData = @model.toJSON()

      if favorite?
        personData.favorite = favorite
      else
        personData.favorite = if Namely.favorites.get(@model.id) then true else false

      personData.addressLink = MobileUtils.mapLink(personData.home_address1+' '+
          personData.home_address2+ ' ' + personData.home_city + ' ' + 
          personData.state + ' ' + personData.home_zip)
      personData.isIOS = MobileUtils.isIOS()
      @$el.html(@template(person: personData))
