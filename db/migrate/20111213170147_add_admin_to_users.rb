class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :default => false
										 # add a default to false setting
					#nils are false in a boolean context, but setting default is clearer
  end
end
