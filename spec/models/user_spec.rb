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

require 'spec_helper'

describe User do
	
	before(:each) do
		@attr = { :name => "Bork Bork", :email => "swedish@chef.org" }
	end
	
	it "should create a new instance given valid example attributes" do
		User.create!(@attr)
		#create! with a bang returns ActiveRecord::RecordInvalid if it fails
		#if this fails, try running
		#	rake db:test:prepare
	end

	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => "")) #merge updates the entry
		no_name_user.should_not be_valid
		#equiv to no_name_user.valid?.should_not == true
		#RSpec adopts the useful convention of allowing us to test any 
		#boolean method by dropping the question mark and prepending be_
	end

	it "should require an email address" do
		no_email_user = User.new(@attr.merge(:email => ""))
		no_email_user.should_not be_valid
	end

	it "should limit name length to something displayable" do
		long_name = "a" * 65
		overly_long_name_user = User.new(@attr.merge(:name => long_name))
		overly_long_name_user.should_not be_valid
	end

	it "should accept valid email adresses" do
		addresses = %w[user@example.com BorkBork@swedish.co.se dude.abides@lebowski.org]
		addresses.each do |addr|
			invalid_email_user = User.new(@attr.merge(:email => addr))
			invalid_email_user.should be_valid
		end
	end
	
	it "should reject invalid email adresses" do
		addresses = %w[user@example,com BorkBork_at_swedish.co.se dude.abides@lebowski.]
		addresses.each do |addr|
			invalid_email_user = User.new(@attr.merge(:email => addr))
			invalid_email_user.should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
		
	end

	it "should reject email addresses identical in case" do
		upcased_email = "USER@EXAMPLE.COM"
		upcased_email = @attr[:email].upcase
		User.create!(@attr.merge(:email => upcased_email))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end

	describe "passwords" do
		it "should have a password attribute" do
			User.new(@attr).should respond_to(:password)
		end
	end

end
