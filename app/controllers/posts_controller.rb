class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    @categories = Category.all
    @post = Post.new
  end

end
