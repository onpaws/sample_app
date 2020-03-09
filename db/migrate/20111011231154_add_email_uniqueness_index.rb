class AddEmailUniquenessIndex < ActiveRecord::Migration[4.2]
#adds this index to the Users table
  def change
	  add_index :users, :email, :unique => true
	  	#:table_name, :column_name, :options
		#http://api.rubyonrails.org/classes/ActiveRecord/Migration.html
		#http://guides.rubyonrails.org/migrations.html#writing-your-change-method
  end
end
