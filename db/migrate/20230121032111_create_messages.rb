class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :recipient_id
      t.text :message_body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
