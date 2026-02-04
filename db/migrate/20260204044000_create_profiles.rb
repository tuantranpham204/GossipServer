class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles, id: false do |t|
      t.belongs_to :user, primary_key: true, foreign_key: { on_delete: :cascade }
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :bio, default: ""
      t.date :dob
      t.integer :gender, null: false
      t.integer :relationship_status, null: false, default: 0
      t.integer :status, null: false, default: 1
      t.jsonb :avatar_data, default: { public_id: nil, url: "https://i.pinimg.com/736x/cc/58/7b/cc587bf43e916ec9197c8842d675265c.jpg" }

      # Privacy setting attributes
      t.boolean :allow_direct_follows, null: false, default: true
      t.boolean :is_email_public, null: false, default: false
      t.boolean :is_gender_public, null: false, default: true
      t.boolean :is_rel_status_public, null: false, default: false

      t.timestamps
    end
  end
end
