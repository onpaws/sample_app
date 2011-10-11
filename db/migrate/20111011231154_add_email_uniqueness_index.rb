class AddEmailUniquenessIndex < ActiveRecord::Migration
#adds this index to the Users table
  def up
	add_index :users, :email, :unique => true
  end

  def down
	  remove_index :users, :email
  end
end
