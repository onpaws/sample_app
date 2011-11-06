require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
	  before (:each) do
		@user = Factory(:user)
	  end

	  it "should be successful" do
		get :show, :id => @user.id
		#FYI, can also do get :show, :id => @user  #rails is smart enough to use @user.id
		response.should be_success
	  end

	  it "should find the right user" do
		get :show, :id => @user.id
		assigns(:user).should == @user
	  end

	  it "should have the right title" do
		get :show, :id => @user
		response.should have_selector('title', :content => @user.name)
	  end

	  it "should have the user's name" do 
		  get :show, :id => @user
		  response.should have_selector('h1', :content => @user.name)
	  end

	  it "should have a profile image (gravatar)" do 
		  get :show, :id => @user
		  response.should have_selector('h1>img', :class => "gravatar")
	  end
	  
	  it "should have the correct URL" do
		get :show, :id => @user
		response.should have_selector('aside>a', :content => user_path(@user), 
									             :href	  => user_path(@user))
	  end



  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
		response.should be_success
    end


	it "should have the right title" do
		get :new
			response.should have_selector("title", :content => "Sign up")
	end
  end

end
