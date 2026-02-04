class CreateUserRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :user_relations, id: false do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :receiver, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.integer :status, null: false
      t.integer :relation_type, null: false

      t.timestamps
    end
    execute "ALTER TABLE user_relations ADD PRIMARY KEY (requester_id, receiver_id);"
  end
end
