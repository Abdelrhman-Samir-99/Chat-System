class AddTotalMessagesCountToChats < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :total_messages_count, :integer, default: 0, null:false
  end
end
