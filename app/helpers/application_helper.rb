module ApplicationHelper
  def get_img_from_cloud(img_name)
    "https://res.cloudinary.com/deku52155/image/upload/v1568018137/#{img_name}"
  end
end
