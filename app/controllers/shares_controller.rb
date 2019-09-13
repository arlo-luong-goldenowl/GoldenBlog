class SharesController < ApplicationController
  def index
    post_id = params[:id]
    @share = Share.create(
      post_id: post_id,
      user_id: current_user.id,
      url: post_url(post_id)
    )
    @post = Post.find(post_id)
    @post.update_attributes(shares_counter: @post.shares_counter + 1) if @share
    render json: @post
  end
end
