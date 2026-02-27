class AddStatusDataToMessage < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :status_data, :jsonb, default: [ { participant_id: nil, status: Message::STATUS[:UNSENT] } ], array: true
  end
end
