class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @posts = Post.where(status: :approved).order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id], status: :approved)

    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if !@post
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
    @post = Post.find_by(id: params[:id], status: :approved)
    @categories = Category.all

    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if !@post
  end

  def update
    @post = Post.find_by(id: params[:id], status: :approved)

    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if !@post

    if @post.update_attributes(post_params)
      redirect_to posts_path
    else
      @categories = Category.all
      render :edit
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
end
