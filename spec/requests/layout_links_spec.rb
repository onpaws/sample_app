require 'spec_helper'

#have_selector is a substring match, i.e. "X Home" would still match
describe "LayoutLinks" do
	it "should have a homepage at  '/'" do
		get '/'
		response.should have_selector('title', :content => "Home")
	end

	it "should have a contact page at '/contact'" do
		get '/contact'
		response.should have_selector('title', :content => "Contact")
	end

	it "should have an about page at '/about'" do
		get '/about'
		response.should have_selector('title', :content => "About")
	end

	it "should have a help page at '/help'" do
		get '/help'
		response.should have_selector('title', :content => "Help")
	end

	it "should have a sign up page at /signup" do
		get '/signup'
		response.should have_selector('title', :content => "Sign up")
	end

	it "should have the right links on the layout" do
		visit root_path
		response.should have_selector('title', :content => "Home")
		click_link "About"
		response.should have_selector('title', :content => "About")
		click_link "Contact"
		response.should have_selector('title', :content => "Contact")
		click_link "Home"
		response.should have_selector('title', :content => "Home")
		click_link "Sign up now!"
		response.should have_selector('title', :content => "Sign up")

		response.should have_selector('a[href="/"]>img')
				#the >img means not only a root link, but the next tag inside is an <img> tag

	end

end
