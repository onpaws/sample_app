class AddSaltToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :salt, :string
  end
end
