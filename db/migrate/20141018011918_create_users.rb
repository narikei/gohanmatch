class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :provider
      t.string  :uid
      t.string  :nickname
      t.string  :image
      t.integer :sex,     :null => true
      t.boolean :ban,     :default => false
      t.boolean :active,  :default => true
      t.timestamps
    end
  end
end
