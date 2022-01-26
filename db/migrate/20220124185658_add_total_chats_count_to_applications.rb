class AddTotalChatsCountToApplications < ActiveRecord::Migration[6.1]
  def change
    add_column :applications, :total_chats_count, :integer, default: 0, null:false
  end
end
