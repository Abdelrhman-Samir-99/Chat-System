class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  has_secure_token :Application_Token

  def self.find_application_by_token(application_token)
    application = Application.find_by!(Application_Token: application_token)
    $chats_count_cache.set(application_token, application[:chats_count])
    return application
  end

  def self.add_application(application_name)
    application = Application.new
    application.name = application_name
    application.save!
    return application
  end

  def self.destroy_application_by_token(application_token)
    application = Application.find_application_by_token(application_token)
    application.lock!
    $chats_count_cache.del(application_token)
    Application.destroy_by(Application_Token: application_token)

  end

  # should be moved to a new module.
  def self.exists_in_chats_cache(application_token)
    return $chats_count_cache.EXISTS(application_token)
  end

end
