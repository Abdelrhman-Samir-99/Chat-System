class RemoveTotalChatsCountFromChats < ActiveRecord::Migration[6.1]
  def change
    remove_column :chats, :total_chats_count
  end
end
