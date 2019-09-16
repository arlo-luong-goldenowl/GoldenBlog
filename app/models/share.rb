class Share < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_create :shares_counter_increase

  private

  def shares_counter_increase
    @post = Post.find(post_id)
    @post.update_attributes(shares_counter: @post.shares_counter + 1)
  end
end
