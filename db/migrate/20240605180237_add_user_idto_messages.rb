class AddUserIdtoMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column :messages, :sender_id
    remove_column :messages, :receiver_id
    add_reference :messages, :user, null: false, foreign_key: true
  end
end
