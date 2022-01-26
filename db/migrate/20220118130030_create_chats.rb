class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :Application, null: false, foreign_key: true
      t.integer :Chat_id
      t.integer :messages_count, default: 0, null:false

      t.timestamps
    end
  end
end
