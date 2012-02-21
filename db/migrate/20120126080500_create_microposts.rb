class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps	#enables created_at and updated_at columns
    end
	# add Lesson 11 @ 3:16 Micropost index
	add_index :microposts, :user_id
  end
end
