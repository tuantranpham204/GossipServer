class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :actor, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.integer :notification_type, null: false
      t.jsonb :content, default: {}
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
