class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  has_secure_token :Application_Token

  def self.find_by_application_token(params)
    application = Application.find_by(Application_Token: params[:application_token])
    return application
  end
end
