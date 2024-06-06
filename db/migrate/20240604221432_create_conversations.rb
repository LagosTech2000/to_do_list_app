class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|

      t.timestamps
    end
  end
end
