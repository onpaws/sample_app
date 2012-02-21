# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

require 'spec_helper'

#PAWS Note: to make a pending test, just declare an 
#	it "should do something"
#without the do ... end part

describe User do
	before(:each) do
		@attr = { 
			:name => "Bork Bork", 
			:email => "swedish@chef.org", 
			:password => "p@ssword", 
			:password_confirmation => "p@ssword"
		}
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
		it "should have a password confirmation attribute" do
			User.new(@attr).should respond_to(:password_confirmation)
		end
	end
	describe "password validations" do
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		end
		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
		end
		it "should reject short passwords" do
			shortPassword = "a" * 5
			hashToTest = @attr.merge(:password => shortPassword, :password_confirmation => shortPassword)
			User.new(hashToTest).should_not be_valid
		end
		it "should reject passwords that are too long" do
			longPassword = "a" * 65
			hashToTest = @attr.merge(:password => longPassword, :password_confirmation => longPassword)
			User.new(hashToTest).should_not be_valid
		end
	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end
		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end
		it "should not have a blank encrypted password attribute" do
			@user.encrypted_password.should_not be_blank
		end
		it "should have a salt" do
			@user.should respond_to(:salt)
		end
		describe "has_password? method" do
			it "should exist" do
				@user.should respond_to(:has_password?)
			end
			it "should return true if passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end
			it "should return false if the passwords don't match" do
				@user.has_password?("invalid").should be_false
			end
		end
		describe "authenticate method" do 
			it "should exist" do
				User.should respond_to(:authenticate)
			end
			it "should return nil if email doesn't match password" do
				User.authenticate(@attr[:email], "wrongpass").should be_nil
			end
			it "should return nil for an email address with no user" do
				User.authenticate("nota@realemail.com", @attr[:password]).should be_nil
			end
			it "should return the user on email/password match" do
				User.authenticate(@attr[:email], @attr[:password]).should == @user
			end
		end
	end
	end
	describe "admin attribute" do
		before(:each) do
			@user = User.create!(@attr)
		end

		it "should respond to admin" do
			@user.should respond_to(:admin)
		end

		it "should not be an admin by default" do
			@user.should_not be_admin
							#RSpec convention: be_something == @user.admin? should_not be_true
							#be_something adds the question mark.	
		end

		it "should be convertible into an admin" do
			@user.toggle!(:admin) #the ! actually writes change to database, otherwise its only in memory
			@user.should be_admin
		end
	end

	describe "micropost association" do 
		before(:each) do
			@user = User.create(@attr)
			@mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
			@mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
													   #normally you can't set created_at - Factory Girl allows this
		end
		it "should have a micropost attribute" do
			@user.should respond_to(:microposts)
		end

		it "should have microposts in correct order" do
			@user.microposts.should == [@mp2, @mp1]
		end

		it "should destroy associated microposts" do
			@user.destroy
			[@mp1, @mp2].each do |micropost|
				Micropost.find_by_id(micropost.id).should be_nil
			end
		end

		it "should destroy associated microposts - with lambda function" do
			@user.destroy
			[@mp1, @mp2].each do |micropost|
				lambda do
					Micropost.find(micropost)
				end.should raise_error(ActiveRecord::RecordNotFound)
			end
		end

		describe "status feed" do
			it "should have a feed" do
				@user.should respond_to(:feed)
			end
			it "should include the users's own microposts" do
				@user.feed.should include(@mp1)		#manipulating microposts: 35:10
				@user.feed.should include(@mp2)
			end
			it "should not include a different user's microposts" do
				mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
				@user.feed.should_not include(mp3)
			end
		end

	end
end
