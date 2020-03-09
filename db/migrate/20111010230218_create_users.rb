class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
	  #automanages the created_at and updated_at columns
    end
  end
end
