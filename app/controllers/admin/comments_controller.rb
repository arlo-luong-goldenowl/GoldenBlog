class Admin::CommentsController < Admin::BaseAdminController

  def index
    @comments = Comment.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:success] = 'Comment was successfully deleted.'
      redirect_to admin_comments_path
    else
      flash[:error] = 'Something went wrong'
      redirect_to admin_comments_path
    end
  end
end
