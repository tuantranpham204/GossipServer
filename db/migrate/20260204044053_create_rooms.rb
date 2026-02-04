class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :room_type, null: false
      t.jsonb :metadata

      t.timestamps
    end
  end
end
