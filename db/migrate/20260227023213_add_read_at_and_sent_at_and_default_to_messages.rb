class AddReadAtAndSentAtAndDefaultToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :read_at, :datetime
    add_column :messages, :sent_at, :datetime
    change_column_default :messages, :message_type, :original
    change_column_default :messages, :is_deleted, false
  end
end
