class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    @posts = Post.where(status: :approved)
  end

  def show
    @post = Post.find_by(id: params[:id])

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
    @post = Post.find_by(id: params[:id])
    @categories = Category.all
    # render error page if post no exist or doesn't belong to user
    if(!@post || @post.user.id != current_user.id)
      return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found)
    end
  end

  def update
    @post = Post.find_by(id: params[:id], status: :approved)
    # render error page if post no exist or doesn't belong to user
    if(!@post || @post.user.id != current_user.id)
      return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found)
    end

    if @post.update_attributes(post_params)
      flash[:success] = 'Post was successfully edited.'
      redirect_to profile_users_path(status: :new)
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    # render error page if post no exist or doesn't belong to
    if(!@post || @post.user.id != current_user.id)
      return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found)
    end

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
                    keyword: "%#{@text.downcase}%"
                  )
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :category_id, :image)
    end
end
