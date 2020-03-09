class AddAdminToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :admin, :boolean, :default => false
										 # add a default to false setting
					#nils are false in a boolean context, but setting default is clearer
  end
end
