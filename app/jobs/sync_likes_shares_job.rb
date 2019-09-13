class SyncLikesSharesJob < ApplicationJob
  def perform
    users = User.where(provider: :facebook)
    users.each do |user|
      if !user.token.blank?
        graph_result_from_user = HTTP.get("https://graph.facebook.com/me?fields=id,name,posts{link,likes.summary(true),shares}&access_token=#{user.token}")

        graph_result_from_user = JSON.parse(graph_result_from_user)
        all_posts = graph_result_from_user["posts"]["data"]

        all_posts.each do |post|
          puts "================= start ==================="
          puts post["link"] if post["link"]
          puts post["shares"]["count"] if post["shares"]
          puts post["likes"]["data"].length if post["likes"]
          puts "================= end ==================="
        end
      end
    end
  end
end
