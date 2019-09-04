$ ->
  $('#customFile').bind('change', ->
    previewImageId = $(this).data('preview-image')
    set_image_to_preview(this,previewImageId)
  )

set_image_to_preview = (input, element_id) ->
    if (input.files && input.files[0])
      reader = new FileReader()

      reader.addEventListener "load", (e) ->
        preview = $(element_id)
        preview_image = $('<img />', {
          src: e.target.result,
          style: 'width:100%'
        })
        preview_image_name = $('<i />').html(input.files[0].name)
        preview_element = $('<div />').append(preview_image_name).append(preview_image)
        preview.html(preview_element)

      reader.readAsDataURL(input.files[0])
