class CreateMatchUsers < ActiveRecord::Migration
  def change
    create_table :match_users do |t|
      t.integer :early_user_id
      t.integer :late_user_id
      t.integer :from_user_id
      t.integer :to_user_id
      t.boolean :is_match,     :null => true
      t.timestamps
    end
  end
end
