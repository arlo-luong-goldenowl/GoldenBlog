class Admin::CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :is_admin

  def index
    @comments = Comment.paginate(page: params[:page], per_page: 8).order(created_at: :desc)
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
