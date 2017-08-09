define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class AccessFieldGroupBundlesGridView extends Backbone.View
    el: '#field_group_grid'

    events:
      'click .info_popup_button': 'clickInfo'

    clickInfo: (e, r, status, xhr) ->
      e.preventDefault()
      data_id=$(e.currentTarget).attr('data')
      @$el.find(".popup_section_"+data_id).toggle().siblings('.popup').hide()

