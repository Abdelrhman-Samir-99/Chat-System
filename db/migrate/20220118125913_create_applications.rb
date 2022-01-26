class CreateApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :applications do |t|
      t.string :Application_Token
      t.string :name
      t.integer :chats_count, default: 0, null: false

      t.timestamps
    end
    add_index :applications, :Application_Token, unique: true
  end
end
