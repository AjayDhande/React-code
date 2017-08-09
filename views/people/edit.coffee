define ['jquery', 'underscore', 'backbone', 'utils',
        'collections/office',
        'collections/country',
        'collections/skilltag',
        'views/components/country_subdivision',
        'views/components/select_editor',
        'views/people/edit_general_office_location',
        'views/people/edit_general_user_bio',
        'views/people/confirm_navigation',
        'views/skilltag/form',
        'views/people/edit_goals'
        'nested_form',
        'jquery.custom-file', 'jquery.validate', 'jquery.tokeninput','jqueryui'], ($, _, Backbone, Utils,
        OfficeCollection,
        CountryCollection,
        SkillTagCollection,
        CountrySubdivisionView,
        SelectEditorView,
        EditGeneralOfficeLocationView,
        EditGeneralUserBioView,
        ConfirmNavigationView,
        SkillTagFormView,
        EditGoalsView) ->

  class EditView extends Backbone.View
    el: '#employee-form'
    events:
      'change #user_job_tier_id': 'onTierSelectChange',
      'change .dollar': 'onDollarChange',
      'click #photo-remove': 'onPhotoRemove',
      'click #toggle-history': 'onHistoryToggle',
      'click .delete-history': 'onHistoryDelete',
      'click #add-history': 'onHistoryAdd',
      'change #user_user_status_id': 'onUserStatusChange'

    initialize: ->
      @isDirty = false

      if $('#field_office_location').length
        Namely.countries = new CountryCollection()
        Namely.countries.fetch()

        @offices = new OfficeCollection()
        @offices.fetch success: =>
          new EditGeneralOfficeLocationView
            collection: @offices
            el: $('#field_office_location')
      
      $('.country-subdivision').each (index, element) ->
        new CountrySubdivisionView
          el: element

      new EditGeneralUserBioView
        el: $('#employee-form')

      new EditGoalsView
        el: $('#reference-goals')

      $('.select-editor').each (idx, el) =>
        new SelectEditorView(el: el)
      @$el.bind('nested:fieldAdded', _.bind(@setupFields, @))
      @setupDob()
      @setupFields()

      $('#user_image').customFile
          status:false,
          text:'Choose Photo',
          selected:'Photo Selected'

      $('#user_profile_attributes_resume').customFile
        pretext: 'Select a resume.'

      $('.right-col .doc').customFile
        pretext:'Choose File',
        selected:'Selected'

      $('#user_dotted_line_reports_to_tokens').tokenInput "/people",
          theme: "namely",
          preventDuplicates:true,
          onResult: Utils.convertObjectsToTokens

      $('#user_native_language_id').tokenInput "/languages?q=",
          theme: "namely",
          tokenLimit: 1,
          preventDuplicates:true

      $('#user_language_tokens').tokenInput "/languages?q=",
          theme: "namely",
          preventDuplicates: true

      $('#form-nav a').click _.bind(@onFormNavClick, @)

      $("#employee-form").on 'click', '.button, input, label, .sbSelector, .close, .skill_tag_form, .delete, textarea',  =>
        @isDirty = true

      if @$('#skill_tag_edit_form').length
        @editSkills()

    onPhotoRemove: (e) ->
      e.preventDefault()
      e.stopPropagation()
      $el = $(e.currentTarget)
      $el.html('Save to Remove')
      $('input#image_remove').val(true)

    onHistoryToggle: (e) ->
      $el = $(e.currentTarget)
      toggleHistory = @toggleHistory
      $('#history').slideToggle(() -> toggleHistory($el, @))

    toggleHistory: (toggle, history) ->
      if $(history).is(':visible')
        toggle.text('Hide History')
        $('#user_job_title_id').prop('disabled', true)
      else
        toggle.text('Edit History')
        $('#user_job_title_id').prop('disabled', false)

    onHistoryDelete: (e) ->
      $el = $(e.currentTarget)
      $el.parent().remove();

    onHistoryAdd: (e) ->
      $el = $(e.currentTarget)
      firstJobTitle = $($el.parent().find('.job-title')[0])
      jobTitle = firstJobTitle.clone(false)
      jobTitle.find('.start-date').remove()
      jobTitle.find('.date').show();
      jobTitle.find('.delete-history').css(display: 'inline-block');
      jobTitle.find('select').val('')
      jobTitle.find('input.date')
              .attr('value', '')
              .attr('id', '')
              .removeClass('hasDatepicker')
              .removeData('datepicker')
              .unbind()
              .datepicker
        dateFormat:'yy-mm-dd'
        changeMonth:true
        changeYear:true
      $el.before(jobTitle)

    setupFields: ($el)->
      @$el.find('input.date:visible').not('#user_dob').datepicker
        dateFormat:'yy-mm-dd'
        changeMonth:true
        changeYear:true

      @$el.find('.history input.date').datepicker
        dateFormat:'yy-mm-dd'
        changeMonth:true
        changeYear:true

      @$el.find('.subgoals input.date').datepicker
        dateFormat:'yy-mm-dd'
        changeMonth:true
        changeYear:true

    editSkills: ->
      if NamelyDataSkillTags?
        skillTagData = NamelyDataSkillTags
      else
        skillTagData = []
      collection = new SkillTagCollection(skillTagData)
      new SkillTagFormView(collection: collection)
      tags = autocompleteSkillTags.map (item) -> _.unescape(item)
      $('#skill_tag').autocomplete
        source: tags

    setupDob: ->
      $('#user_dob').datepicker
        defaultDate: "-25y",
        yearRange: "c-90:c+25"
        changeMonth:true
        changeYear:true
        dateFormat:'yy-mm-dd'

    onDollarChange: (e) ->
      $el = $(e.currentTarget)
      $el.val($el.val().replace(/[^-\d\.]/g, ""))

    # Job Titles
    onTierSelectChange: ->
      if $('#user_job_tier_id').length
        @current_title_id = $('#user_job_title_id').val()
        @$('#user_job_title_id').empty().show()
        if tierID = $('#user_job_tier_id').val()
          $.ajax
            url: "/job_titles/#{ tierID }/children",
            type: 'GET'
            success: _.bind(@buildJobTitles, @)
        else
          @$('#user_job_title_id').hide()
          @buildJobTitles([{id:0, title:""}])

    buildJobTitles: (results) ->
      out = ''
      for title in results
        if parseInt(@current_title_id) == parseInt(title.id)
          out += "<option selected='selected' value='#{ title.id }'>#{ title.title }</option>"
        else
          out += "<option  value='#{ title.id }'>#{ title.title }</option>"
      @$('#user_job_title_id').html(out)

    onFormNavClick: (e) ->
      $currentTarget = $(e.currentTarget)
      thisGuid = $currentTarget.attr('guid')

      if thisGuid == '' || @isDirty
        e.preventDefault()
        e.stopPropagation()
        new ConfirmNavigationView(
          targetHref :$currentTarget.attr('href')
          targetSection : $currentTarget.attr('data')
          targetGuid : thisGuid
        ).render()

    onUserStatusChange: (e) ->
      $currentTarget = $(e.currentTarget)
      if $currentTarget.children(':selected').text() == 'Inactive Employee' && $currentTarget.data('direct-reports')
        new ConfirmNavigationView(
          targetHref : $('#form-nav a:first').attr('href')
          targetSection : $('#form-nav a:first').attr('data')
          targetGuid : false
          statusChange : true
        ).render()
