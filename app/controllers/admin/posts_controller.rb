class Admin::PostsController < Admin::BaseAdminController
  before_action :prepare_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end

  def show
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
    @categories = Category.all
  end

  def update
    if @post.update_attributes(post_params)
      # send mail notification if admin approved some posts
      MailNotificationWorker.perform_async("new", @post.id) if post_params[:status] == "approved"
      flash[:success] = 'Post was successfully updated.'
      redirect_to admin_posts_path
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
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

  def prepare_post
    @post = Post.find(params[:id])
  end
end
