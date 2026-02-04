class CreateRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :receiver, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.integer :request_type
      t.integer :status

      t.timestamps
    end
    execute "ALTER TABLE requests ADD CONSTRAINT unique_constraints UNIQUE (sender_id, receiver_id, request_type);"
  end
end
