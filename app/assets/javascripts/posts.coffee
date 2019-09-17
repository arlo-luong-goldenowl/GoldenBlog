$(document).on('ready turbolinks:load', ->
  $('#customFile').bind('change', ->
    previewImageId = $(this).data('preview-image')
    set_image_to_preview(this,previewImageId)


  $('.comment-input > form > textarea').on 'input', ->
    scroll_height = $(this).prop('scrollHeight')
    if scroll_height > 84
      $(this).css('overflow', 'visible')
    else
    # if scrollHeight < 84
      delta = 150 + 35 + scroll_height
      new_height = "calc(100% - " + delta + "px)"
      $('.post-detail-comments-wrapper').css('height': new_height)
      $(this).css('height', scroll_height + 'px')


  $(window).scroll ->
    next_page_element = $(".pagination > .page-item > .page-link[rel=next]")[0]
    # console.log("next_page_element",next_page_element)
    next_page_href = next_page_element && next_page_element.getAttribute("href");
    # console.log("next_page_href",next_page_href)
    if next_page_href && $(window).scrollTop() > $(document).height() - $(window).height() - 50
      $(".pagination-wrapper")
        .html("<img src='https://res.cloudinary.com/deku52155/image/upload/v1568690774/loader_pacd3k.gif' width='50px' height='50px' />")
        .removeClass("d-none")
      setTimeout ( ->
        $.getScript(next_page_href)
      ), 300

  )

  $('.share-btn').on('click',(e) ->
    e.preventDefault()
    redirectLink = $(this).data('href')
    postId = $(this).data('id')
    FB.ui({ method: 'share', href: redirectLink }, (response) ->
      if response && Array.isArray(response)
        $.ajax({
          url: "/posts/#{postId}/share",
          type: "post",
          dataType: "json",
          success: (data) ->
            postElement = $("#post-#{postId}")
            postSharesElement = postElement.find(".post-shares")
            postSharesElement.html("#{data.shares_counter + data.social_shares_counter} shares");
          ,
          error: (error) ->
        })
    )
  )

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
