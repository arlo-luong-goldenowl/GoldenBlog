class AddLikesSharesToPosts < ActiveRecord::Migration[5.2]
  def up
    add_column :posts, :shares_counter, :integer, default: 0
    add_column :posts, :likes_counter, :integer, default: 0

    posts = Post.all
    posts.each do |post|
      post.shares_counter = Shares.where(post_id: post.id).count
      posts.likes_counter = Likes.where(post_id: post.id).count
    end
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
