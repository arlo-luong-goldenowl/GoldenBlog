module LikesHelper
  def is_like_this_posts?(likes)
    if logged_in?
      likes.any? { |l| l.user_id == current_user.id }
    else
      false
    end
  end
end
