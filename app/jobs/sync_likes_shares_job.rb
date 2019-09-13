class SyncLikesSharesJob < ApplicationJob
  def perform
    users = User.where(provider: :facebook)
    users.each do |user|
      # check and update likes, shares only if user shared atleast 1 post and has access token fb graph api
      if !user.access_token.blank?
        # get data from fb graph api, get all posts with link, likes, shares
        graph_result_from_user = HTTP.get("https://graph.facebook.com/me?fields=id,name,posts{link,likes.summary(true),shares}&access_token=#{user.access_token}")

        return if !graph_result_from_user

        graph_result_from_user = JSON.parse(graph_result_from_user)
        all_posts = graph_result_from_user["posts"]["data"]


        app_url = "youtube.com"
        # app_url = "golden-blog.com"
        # filter all posts has redirect link to GoldenBlog
        all_posts = all_posts.select { |post| post["link"] && post["link"].include?(app_url) }

        all_posts.each do |fb_post|

          @share = Share.find_by(user_id: user.id, url: "http://localhost:3000/posts/4")
          # @share = Share.find_by(user_id: user.id, url: fb_post["link"])
          @post = Post.find(@share.post_id)

          update_options = {}

          update_options[:social_likes_counter] = @post.social_likes_counter + fb_post["likes"]["data"].length if fb_post["likes"]

          update_options[:social_shares_counter] = @post.social_shares_counter + fb_post["shares"]["count"] if fb_post["shares"]

          @post.update_attributes(update_options)
        end
      end
    end
  end
end
