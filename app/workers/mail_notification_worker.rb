class MailNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(post_id, type)
    users = User.all
    post = Post.find(post_id)
    users.each do |user|
      if type == "new"
        # PostMailer.post_released_email(user, post).deliver
      elsif type == "update"
        # PostMailer.post_edited_email(user, post).deliver
      else
        # PostMailer.post_deleted_email(user).deliver
      end
    end
  end
end
