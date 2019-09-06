$ ->
  $('.change-image-text').on('click', (e) ->
    e.preventDefault()
    $('#customFile').trigger('click')
  )

  $('#customFile').bind('change', ->
    previewImageId = $(this).data('preview-image')
    set_image_to_preview(this,previewImageId)
  )

  set_image_to_preview = (input, element_id) ->
    if (input.files && input.files[0])
      reader = new FileReader()
      reader.addEventListener "load", (e) ->
        preview = $(element_id)
        preview.attr('src', e.target.result)
        console.log(e.target.result)
      reader.readAsDataURL(input.files[0])
