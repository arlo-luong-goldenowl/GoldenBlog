class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :prepage_post, only: [:show, :edit, :update, :destroy]
  before_action :check_post_exist, only: [:show, :edit, :update, :destroy]
  before_action :check_post_author_with_current_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.where(status: :approved)
  end

  def show
    # only access post detail page if that post was approved
    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if @post.status != "approved"
  end

  def new
    @categories = Category.all
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = 'Post was successfully edited.'
      redirect_to profile_users_path(status: :new)
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = 'Post was successfully deleted.'
      redirect_to profile_users_path(status: :new)
    else
      flash[:danger] = 'Something went wrong'
      redirect_to profile_users_path(status: :new)
    end
  end

  def search
    @text = params[:post_search][:text]
    @search_result = Post
                  .joins(:category)
                  .where(status: :approved)
                  .where('
                    LOWER(categories.name) like :keyword OR
                    LOWER(posts.content) like :keyword OR
                    LOWER(posts.title) like :keyword',
                    keyword: "%#{@text}%"
                  )
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :image)
  end

  def prepage_post
    @post = Post.find_by(id: params[:id])
  end

  def check_post_exist
    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if !@post
  end

  def check_post_author_with_current_user
    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if @post.user != current_user
  end
end
