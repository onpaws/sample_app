# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
	attr_accessible	:content
	
	#from the rails console, we cannot do a mass assignment
	#1.9.3p0 :002 > Micropost.new(:content => "foobar", :user_id => 1)
	#WARNING: Can't mass-assign protected attributes: user_id
	# => #<Micropost id: nil, content: "foobar", user_id: nil, created_at: nil, updated_at: nil> 

	belongs_to :user
	
	validates :content, :presence => true, :length => { :maximum => 140 }
	validates :user_id, :presence => true

	default_scope :order => "microposts.created_at DESC"
	#appends the SQL clause to the query rails uses. establishes a 'sane' default.
	#see http://archives.ryandaigle.com/articles/2008/11/18/what-s-new-in-edge-rails-default-scoping
end

