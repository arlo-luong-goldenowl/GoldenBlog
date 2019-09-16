class AddSocialLikesSharesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :social_likes_counter, :integer, default: 0
    add_column :posts, :social_shares_counter, :integer, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
