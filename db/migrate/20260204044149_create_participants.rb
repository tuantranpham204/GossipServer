class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants, id: false do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, to_column: :id }
      t.references :room, null: false, foreign_key: { to_table: :rooms, to_column: :id }
      t.integer :role, null: false

      t.timestamps
    end
    execute "ALTER TABLE participants ADD PRIMARY KEY (user_id, room_id);"
  end
end
