class AddRelationAmountTrackersToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :friends_amount, :integer, default: 0
    add_column :users, :followers_amount, :integer, default: 0
    add_column :users, :following_amount, :integer, default: 0
  end
end
