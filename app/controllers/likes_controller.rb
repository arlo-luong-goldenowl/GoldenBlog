class LikesController < ApplicationController
  before_action :logged_in_user, only: [:like_unlike]

  def like_unlike
    @post = Post.find_by(id: params[:id])

    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if @post.blank?

    is_exist = Like.exists?(post_id: @post.id, user_id: current_user.id)

    !is_exist ? like(@post) : unlike(@post)
  end

  def like(post)
    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if @post.blank?

    @post = post

    Like.create(post_id: @post.id, user_id: current_user.id)
    @status = true
    @post.update_attributes(likes_counter: @post.likes_counter + 1) if !@post.nil?
    respond_to do |format|
      format.js { render 'like_unlike'}
    end
  end

  def unlike(post)
    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if @post.blank?

    @post = post

    Like.where(post_id: @post.id, user_id: current_user.id).delete_all
    @status = false
    @post.update_attributes(likes_counter: @post.likes_counter - 1) if !@post.nil?
    respond_to do |format|
      format.js { render 'like_unlike'}
    end
  end
end
