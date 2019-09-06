class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :likes
  mount_uploader :image, ImageUploader
end
