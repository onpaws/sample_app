class AddEmailUniquenessIndex < ActiveRecord::Migration
#adds this index to the Users table
  def change
	  add_index :users, :email, :unique => true
	  	#:table_name, :column_name, :options
		#http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
		#http://guides.rubyonrails.org/migrations.html#writing-your-change-method
  end

### OLD WAY ###
#  def up
#	add_index :users, :email, :unique => true
# end

#  def down
#	  remove_index :users, :email
#  end
end
