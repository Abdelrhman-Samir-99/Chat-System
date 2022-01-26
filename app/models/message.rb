class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
 
  # association properties
  belongs_to :Application
  belongs_to :Chat
  
  settings do
    mappings dynamic: false do
      indexes :Application_id, type: :integer
      indexes :Chat_id, type: :integer
      indexes :body, type: :text, analyzer: :english
    end
  end

  ###########################################################################################################

  # helper methods

  def self.find_messages_by_chat_id_and_token(chat_id, application_token)
    chat = Chat.find_chat_by_id_and_token(chat_id, application_token)
    messages = Message.where(Chat_id: chat[:id], Application_id: chat[:Application_id])
    return messages
  end

  def self.find_message_by_chat_id_and_token_and_message_id(chat_id, application_token, message_id)
    chat = Chat.find_chat_by_id_and_token(chat_id, application_token)
    message = Message.find_by!(message_id: message_id, Chat_id: chat[:id], Application_id: chat[:Application_id])
    return message
  end

  ###########################################################################################################

  def self.add_message(application_token, chat_id, body)
    message = Message.new
    ActiveRecord::Base.transaction do
      chat = Chat.find_chat_by_id_and_token(chat_id, application_token)
      chat.lock!

      chat.update!(messages_count: chat[:messages_count] + 1, total_messages_count: chat[:total_messages_count] + 1)
      $messages_count_cache.set(application_token + "+" + chat_id.to_s, chat[:messages_count])
   
      message.body = body
      message.Application_id = chat[:Application_id]
      message.Chat_id = chat[:id]
      message.message_id = chat[:total_messages_count]
      message.save!

    end
    return message
  end

  def self.destroy_message_by_chat_id_and_token_and_message_id(chat_id, application_token, message_id)
    
     ActiveRecord::Base.transaction do
      chat = Chat.find_chat_by_id_and_token(chat_id, application_token)
      chat.lock!
      message = self.find_message_by_chat_id_and_token_and_message_id(chat_id, application_token, message_id)
      message.lock! # maybe another thread may try to update this row?...
      message.destroy!
      chat.update!(messages_count: chat[:messages_count] - 1)
      $messages_count_cache.set(application_token + "+" + chat_id.to_s, chat[:messages_count])
    end
   
  end

  def self.update_message_by_chat_id_and_token_and_message_id(chat_id, application_token, message_id, body)
    message = Message.find_message_by_chat_id_and_token_and_message_id(chat_id, application_token, message_id)
    message.lock!

    message.update!(body: body)
    return message
  end
end
