class AddTotalCountToChats < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :total_chats_count, :integer, default: 0, null:false
  end
end
