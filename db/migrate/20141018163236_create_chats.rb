class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :user_id
      t.integer :early_user_id
      t.integer :late_user_id
      t.text    :content
      t.boolean :ban,     :default => false
      t.timestamps
    end
  end
end
