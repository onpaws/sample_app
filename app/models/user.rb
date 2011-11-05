# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	#Important! Limit what attributes are accessible
	#should do this as soon as model is created.
	attr_accessible :name, :email

	#define a email validator regex
	#see http://ruby.railstutorial.org/chapters/modeling-and-viewing-users-one#table:email_regex
	#\A is beginning of string, \z is end, /i insensitive
	valid_email = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	

	#syntax new to rails 3.1
	validates :name, :presence => true,
						:length => { :maximum => 64 }

	validates :email, :presence => true,
						:format => { :with => valid_email },
						#format checks against the regex
						:uniqueness => { :case_sensitive => false }
						#uniquess being true is implicit
						#warning: this on its own DOES NOT guarantee uniqueness. use an index 
						
end
