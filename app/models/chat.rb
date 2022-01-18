class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :Application

  def self.find_by_application_token_and_Chat_id(params)
   application = find_by_application_token_and_Chat_id[params[:Chat_id]]
   chats = Chat.find_by(Chat_id: params[:Chat_id], Application_id: params[:id])
   return chats
  end
end
