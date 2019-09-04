class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @posts = Post.all
      .select(:id, :user_id, :content, :image, :created_at)
      .order(created_at: :desc)
      .limit(5)
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
      # flash[:success] = "Object successfully created"
      redirect_to posts_path
    else
      @categories = Category.all
      render :new
    end
  end

  private
    def post_params
      params.require(:post).permit(:title ,:content, :category_id ,:image)
    end
end
