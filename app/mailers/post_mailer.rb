class PostMailer < ApplicationMailer
  default from: "from@example.com"

  def post_released_email(user, post)
    @user = user
    @post = post
    @current_date = Time.current.strftime("%d/%m/%Y %H:%M")
    mail to: @user.email, subject: "Golden blog notification"
  end

  def post_deleted_email(user, post_title, author)
    @user = user
    @post_title = post_title
    @author = author
    @current_date = Time.now.strftime("%d/%m/%Y %H:%M")
    mail to: @user.email, subject: "Golden blog notification"
  end

  def post_edited_email(user, post)
    @user = user
    @post = post
    @current_date = Time.now.strftime("%d/%m/%Y %H:%M")
    mail to: @user.email, subject: "Golden blog notification"
  end
end
