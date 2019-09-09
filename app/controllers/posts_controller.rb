class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @posts = Post.all.order(created_at: :desc)
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
      redirect_to posts_path
    else
      @categories = Category.all
      render :new
    end
  end

  def search
    @text = params[:post_search][:text]
    @search_result = Post
                  .joins(:category)
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
