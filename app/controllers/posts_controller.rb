class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @posts = Post.all.order(created_at: :desc).limit(5)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @categories = Category.all
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Object successfully created"
      redirect_to new_post_path
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  private
    def post_params
      params.require(:post).permit(:title ,:content, :category_id ,:image)
    end
end
