class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :Application, null: false, foreign_key: true
      t.references :Chat, null: false, foreign_key: true
      t.text :body
      t.integer :message_id

      t.timestamps
    end
  end
end
