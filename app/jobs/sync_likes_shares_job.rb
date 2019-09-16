class SyncLikesSharesJob < ApplicationJob
  def perform
    update_likes_shares()
  end

  def update_likes_shares
    posts = Post.all
    posts.each do |post|
      # filter all users shared this post, logged with facebook and has access_token
      users = filter_users_shared_post(post.id)
      # count total likes, shares of one post in social network
      total_likes_shares = calculate_total_likes_shares_of_each_post(users, post.id)
      # only update if likes > 0 or shares > 0
      if total_likes_shares[:likes] > 0 || total_likes_shares[:shares] > 0
        Post.find(post.id).update_attributes(
          social_likes_counter: total_likes_shares[:likes],
          social_shares_counter: total_likes_shares[:shares]
        )
      end
    end
  end

  def filter_users_shared_post(post_id)
    User
      .joins(:shares)
      .where(
        shares: {post_id: post_id},
        users: {provider: "facebook"}
      )
      .select(:id, :name, :email, :access_token, :provider)

  end

  def calculate_total_likes_shares_of_each_post(users, post_id)
    app_url = "secret-journey-76001"
    total_likes_shares = {
      likes: 0,
      shares: 0
    }

    users.each do |user|
      likes_shares = get_likes_shares_of_golden_post_from_each_user(user, post_id, app_url)
      total_likes_shares[:likes] += likes_shares[:likes]
      total_likes_shares[:shares] += likes_shares[:shares]
    end

    total_likes_shares
  end

  def get_likes_shares_of_golden_post_from_each_user(user, post_id, app_url)
    found_posts = Array.new
    likes_counter = 0
    shares_counter = 0
    if !user.access_token.blank?
      graph_result_from_user = HTTP.get("https://graph.facebook.com/me?fields=id,name,posts{link,likes.summary(true),shares}&access_token=#{user.access_token}")

      graph_result_from_user = JSON.parse(graph_result_from_user)

      all_posts = graph_result_from_user["posts"]["data"]

      found_posts = all_posts.select do |fb_post|
        !fb_post["link"].blank? && fb_post["link"].include?(app_url)
      end
    end

    found_posts.each do |fb_post|
      likes_counter += fb_post["likes"] ? fb_post["likes"]["data"].length : 0
      shares_counter += fb_post["shares"] ? fb_post["shares"]["count"] : 0
    end

    return {
      likes: likes_counter,
      shares: shares_counter
    }
  end
end
