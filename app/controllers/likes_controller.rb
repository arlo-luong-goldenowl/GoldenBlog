class LikesController < ApplicationController
  before_action :logged_in_user, only: [:like_unlike]

  def like_unlike
    @post = Post.find(params[:id])
    is_exist = Like.exists?(post_id: @post.id, user_id: current_user.id)
    if !is_exist
      like(@post)
    else
      unlike(@post)
    end
  end

  def like(post)
    @post = post
    Like.create(post_id: @post.id, user_id: current_user.id)
    @status = true
    respond_to do |format|
      format.js { render 'like_unlike'}
    end
  end

  def unlike(post)
    @post = post
    Like.where(post_id: @post.id, user_id: current_user.id).delete_all
    @status = false
    respond_to do |format|
      format.js { render 'like_unlike'}
    end
  end
end
