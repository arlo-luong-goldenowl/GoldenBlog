class MailNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(post_id)
    users = User.all
    post = Post.find(post_id)
    users.each do |user|
      PostMailer.post_released_email(user, post).deliver
    end
  end
end
