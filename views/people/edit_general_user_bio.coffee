define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  class EditGeneralUserBioView extends Backbone.View
    events:
      'keydown #user_bio': 'checkUserBio'
      'keyup #user_bio': 'checkUserBio'
      'blur #user_bio': 'checkUserBio'

    checkUserBio: (e) ->
      $target = $(e.currentTarget)
      if $target.val().length > bioLength
        $target.val( $target.val().substring(0, bioLength) )
      
      
    
