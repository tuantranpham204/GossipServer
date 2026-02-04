class CreateMessages < ActiveRecord::Migration[8.1]
  create_table :messages do |t|
    t.references :room, null: false, foreign_key: { to_table: :rooms, to_column: :id }
    t.references :sender, null: false, foreign_key: { to_table: :users, to_column: :id }
    t.text :content
    t.integer :message_type
    t.jsonb :attachment_data
    t.boolean :is_deleted

    t.timestamps
  end
end
