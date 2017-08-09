define ['jquery', 'underscore', 'backbone', 'plupload'], ($, _, Backbone, plupload) ->
  class AttachView extends Backbone.View
    el: '#import-attachment-form'

    initialize: ->
      id = @options.attach_id
      options =
        runtimes: 'html5,html4',
        url: "/imports/#{id}/attach",
        browse_button: 'import-file',
        container: 'import-attachment-form',
        multipart: true,
        multipart_params: {
          'authenticity_token': $("input[name=authenticity_token]").val()
        },
        filters: [{title: "Image files", extensions: "jpg,jpeg,gif,png"},
                  {title: "Documents", extensions: "pdf,doc,docx,odt,epub,rtf,txt"},
                  {title: "Zip file", extensions: "zip"}],

      @uploader = new plupload.Uploader(options)
      @uploader.bind('QueueChanged', @onUpload, @)
      @uploader.bind('Error', @onError, @)
      @uploader.bind('FilesAdded', @onFilesAdded, @)
      @uploader.bind('UploadProgress', @onUploadProgress, @)
      @uploader.bind('FileUploaded', @onFileUploaded, @)
      @uploader.init()

    onUpload: (up) ->
      up.start()

    onError: ->
      console.log('Error happened')

    onFilesAdded: (up, files) ->
      for file in files
        @$('#uploading').append('<li id="' + file.id + '">Uploading: ' + file.name + ' (' + plupload.formatSize(file.size) + ') <b></b>' + '</li>')

    onUploadProgress: (up, file) ->
      @$('#' + file.id + " b").html(file.percent + "%")

    onFileUploaded: (up, file, r) ->
      r = jQuery.parseJSON(r.response)
      if (r.success)
        @$('#' + file.id).remove()
        for filename in r.filenames
          @$('#uploaded').append($('<li>', {text: filename}))

      else
        console.log('error uploading')

