class Chat < ApplicationRecord
  # association properties
  has_many :messages, dependent: :destroy
  belongs_to :Application

  # helper functions

  def self.get_application_by_token(application_token)
    return Application.find_application_by_token(application_token)
  end

  def self.find_chats_by_token(application_token)
    application = self.get_application_by_token(application_token)
    
    chats = Chat.where(Application_id: application[:id])

    return chats
  end

  def self.find_chat_by_id_and_token(chat_id, application_token)
    application = self.get_application_by_token(application_token)

    chat = Chat.find_by!(Application_id: application[:id], Chat_id: chat_id)
    $messages_count_cache.set(application_token + "+" + chat[:chat_id].to_s, 0)
  
    return chat
  end
  
  ##################################################################################################

  def self.add_chat(application_token)
    chat = Chat.new      
      
    ActiveRecord::Base.transaction do
      application = self.get_application_by_token(application_token)
      
      application.lock!
      
      application.update!(total_chats_count: application[:total_chats_count] + 1, chats_count: application[:chats_count] + 1)
      chat.Application_id = application[:id]
      chat.Chat_id = application[:total_chats_count]
      chat.save!
      $chats_count_cache.set(application[:application_token], application[:chats_count])
      $messages_count_cache.set(application_token + "+" + chat[:Chat_id].to_s, 0)
    end
    return chat
  end


  def self.destroy_chat_by_id_and_token(chat_id, application_token)
    ActiveRecord::Base.transaction do
      chat = self.find_chat_by_id_and_token(chat_id, application_token)
      chat.lock! # maybe someone will try to insert a new message?... so this may happen after we delete this chat?

      application = Application.find_application_by_token(application_token)
      application.lock!

      
      application.update!(chats_count: application[:chats_count] - 1)
      Chat.destroy_by(id: chat[:id])
      $chats_count_cache.set(application[:application_token], application[:chats_count])
      $messages_count_cache.del(application_token + "+" + chat_id.to_s)
    end
  end


  # should be moved to a new module.
  def self.exists_in_messages_cache(application_token, chat_id)
    return $messages_count_cache.EXISTS(application_token + "+" + chat_id.to_s)
  end

  def self.fetch_from_messages_cache(application_token, chat_id)
    return $messages_count_cache.get(application_token + "+" + chat_id.to_s)
  end
end