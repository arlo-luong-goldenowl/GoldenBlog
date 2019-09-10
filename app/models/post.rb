class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :likes, dependent: :destroy
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy do
    def top_2
      limit(2)
    end
  end

  mount_uploader :image, ImageUploader
  validates :title, presence: true, length: { in: 10..255 }
  validates :content, presence: true, length: { minimum: 20 }
  validates :category_id, presence: true
  validates :user_id, presence: true
  validates :image, presence: true
end
