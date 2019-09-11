class PostMailer < ApplicationMailer
  default from: "from@example.com"

  def post_released_email(user, post)
    @user = user
    @post = post
    @current_date = Time.now.strftime("%d/%m/%Y %H:%M")
    mail to: @user.email, subject: "Golden blog notification"
  end

  def post_deleted_email(user, post)
    @user = user
    @post = post
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
