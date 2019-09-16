class SharesController < ApplicationController
  def index
    post_id = params[:id].to_i
    if logged_in?
      @share = Share.create(
        post_id: post_id,
        user_id: current_user.id,
        url: post_url(post_id)
      )
    end
    @post = Post.find(post_id)
    #still allow share and increase shares counter if user not logged
    @post.update_attributes(shares_counter: @post.shares_counter + 1) if !logged_in? && !@post.nil?
    render json: @post
  end
end
