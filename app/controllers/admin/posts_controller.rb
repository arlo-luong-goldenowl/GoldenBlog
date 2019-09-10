class Admin::PostsController < ApplicationController
  before_action :logged_in_user
  before_action :is_admin

  def index
    @posts = Post.paginate(page: params[:page], per_page: 8).order(created_at: :desc)
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
      flash[:success] = 'Post was successfully created.'
      redirect_to admin_posts_path
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @categories = Category.all
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = 'Post was successfully updated.'
      redirect_to admin_posts_path
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = 'Post was successfully deleted.'
      redirect_to admin_posts_path
    else
      flash[:danger] = 'Something went wrong'
      redirect_to admin_posts_path
    end
  end


  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :image, :status)
  end
end
