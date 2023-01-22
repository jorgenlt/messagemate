class CreateChatrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :chatrooms do |t|
      t.integer :recipient_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
