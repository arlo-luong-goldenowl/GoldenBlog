class Admin::CommentsController < Admin::BaseAdminController
  before_action :prepare_comment, only: [:destroy]
  before_action :check_comment_exist, only: [:destroy]

  def index
    @comments = Comment.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end

  def destroy
    if @comment.destroy
      flash[:success] = 'Comment was successfully deleted.'
      redirect_to admin_comments_path
    else
      flash[:error] = 'Something went wrong'
      redirect_to admin_comments_path
    end
  end

  private

  def prepare_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def check_comment_exist
    return render(file: "#{Rails.root}/public/404", layout: false, status: :not_found) if !@comment
  end
end
