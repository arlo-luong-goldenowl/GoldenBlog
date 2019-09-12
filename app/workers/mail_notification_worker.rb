class MailNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(type, *argu)
    users = User.all
    users.each do |user|
      if type == "new"
        PostMailer.post_released_email(user, post).deliver
      elsif type == "update"
        PostMailer.post_edited_email(user, post).deliver
      else
        title = argu[0]
        author = argu[1]
        PostMailer.post_deleted_email(user, title, author).deliver
      end
    end
  end
end
