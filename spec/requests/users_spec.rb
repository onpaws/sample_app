require 'spec_helper'

describe "Users" do

  describe "signup" do

	  describe "failure" do
		  it "should not make a new user" do
			  lambda do
				visit signup_path	
						#use label name, or CSS ID if field has no label
				fill_in "Name",		:with => ""	#deliberately blank
				fill_in "Email",	:with => ""
				fill_in "Password",	:with => ""
				fill_in "Confirm password",	:with => ""
				click_button
				response.should render_template("users/new")		
					#in an integration test it doesn't know the controller - specify it manually
				response.should have_selector("div#error_explanation") #the # specifies the ID of the enclosed tag
					#test for presence of error_explanation div
			  end.should_not change(User, :count)
		  end
	  end

	  describe "success" do
		it "should make a new user" do
			lambda do
				visit signup_path	
						#use label name, or CSS ID if field has no label
				fill_in "Name",		:with => "Han Solo"	#deliberately blank
				fill_in "Email",	:with => "hsolo@example.com"
				fill_in "Password",	:with => "chewie"
				fill_in "Confirm password",	:with => "chewie"
				click_button
				response.should have_selector("div.flash.success", 	#the . specifies the class of the enclosed tag
											  :content => "Welcome" )
				response.should render_template("users/show")		#will follow redirects as listed in routes.rb
			end.should change(User, :count).by(1)
		end
	  end

  end
end
