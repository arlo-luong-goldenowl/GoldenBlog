class Category < ApplicationRecord
  validates :name, presence: true, length: { in: 3..255 }

  has_many :posts
end
