class AddEmailUniquenessIndex < ActiveRecord::Migration
#adds this index to the Users table
  def up
	add_index :users, :email, :unique => true
	#:table_name, :column_name, :options
	#http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
  end

  def down
	  remove_index :users, :email
  end
end
