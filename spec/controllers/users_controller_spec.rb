require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
	describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

	describe "for signed in users" do
	  before(:each) do
		@user = test_sign_in(Factory(:user))
		Factory(:user, :email => "user@example2.com")
		Factory(:user, :email => "darth@vader.com")

		30.times do 
			Factory(:user, :email => Factory.next(:email))
		end

	  end

	  it "should allow access" do
		get :index
		response.should be_success
	  end

	  it "should have the right title" do
		get :index
		response.should have_selector("title", :content => "All users")
	  end

	  it "should have an element for each user" do
		get :index
		User.paginate(:page => 1).each do |user|
			response.should have_selector("li", :content => user.name)
		end
	  end
	
	  it "should paginate users" do
		get :index
		response.should have_selector("div.pagination")
		response.should have_selector("span.disabled", :content => "Previous")
		response.should have_selector("a", :href => "/users?page=2", :content => "2")
		response.should have_selector("a" , :href => "/users?page=2", :content => "Next")
	  end

	end
  end

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
  
  describe "POST 'create'" do
	describe "failure" do
		before(:each) do
			@attr = { :name => "", :email => "", 
					  :password => "", :password_confirm => "" }
		end
		it "should have the right title" do
			post :create, :user => @attr
			response.should have_selector('title', :content => "Sign up") 
			#should be same as sign up page
		end
		it "should render the new page" do
			post :create, :user => @attr
			response.should render_template('new')
		end
		it "should not create the user" do
			lambda do 
				post :create, :user => @attr
			end.should_not change(User, :count)
		end
	end

	describe "success" do
		before(:each) do
			@attr =  { :name => "Foo User", :email => "fuser@example.com",
					   :password => "secret1", :password_confirm => "secret1" }
		end
		it "should create a user" do
			lambda do 
				post :create, :user => @attr
			end.should change(User, :count).by(1)
		
		end
		it "should redirect to the user profile page" do
			post :create, :user => @attr
			response.should redirect_to(user_path(assigns(:user))) 
												#assigns(:user) pulls out actual user object...somehow.
		end
		it "should display the interstitial (in ruby lingo: flash) welcome message" do
			post :create, :user => @attr
			flash[:success].should =~ /welcome to pawstwit/i
		end
		it "should sign the user in" do
			post :create, :user => @attr
			controller.should be_signed_in
		end
	end
  end
  
  describe "GET 'edit'" do
	before(:each) do
	  @user = Factory(:user)
	  test_sign_in(@user)
	end

	it "should be successful" do
		get :edit, :id => @user
		response.should be_success
	end

	it "should have the right title" do
		get :edit, :id => @user
		response.should have_selector("title", :content => "Edit user")
	end

	it "should have a link to change the gravatar" do
		get :edit, :id => @user
		response.should have_selector("a", :href => "http://gravatar.com/emails", :content => "Change")
	end

  end

  describe "PUT 'update'" do
	before(:each) do
	  @user = Factory(:user)
	  test_sign_in(@user)
	end
	  
	describe "failure" do
		before(:each) do
			@attr = { :name => "", :email => "", 
					  :password => "", :password_confirm => "" }
		end

		it "should render the 'edit' page" do
			put :update, :id => @user, :user => @attr
			response.should render_template('edit')
		end

		it "should have the right title" do
			put :update, :id => @user, :user => @attr
			response.should have_selector("title", :content => "Edit user")
		end
	end

	describe "success" do
		before(:each) do
			@attr = { :name => "Freddy Stardust", :email => "fs@maily.com", 
					  :password => "yukyukyuk", :password_confirm => "yukyukyuk" }
		end

		it "should actually change the user's attributes" do
			put :update, :id => @user, :user => @attr
			user = assigns(:user) #reaches inside controller
			@user.reload	#pulls values out of database
			@user.name.should == user.name
			@user.email.should == user.email
			@user.encrypted_password.should == user.encrypted_password
		end

		it "should have a flash message" do
			put :update, :id => @user, :user => @attr
			flash[:success].should =~ /Update/i
		end
	end
  end

	describe "authentication of edit/update actions" do
		before(:each) do
			@user = Factory(:user)
		end

		describe "for non-signed in users" do
			it "should deny access to 'edit'" do
				get :edit, :id => @user
				response.should redirect_to(signin_path)
				flash[:notice].should =~ /sign in/i
			end

			it "should deny access to 'update'" do
				get :update, :id => @user, :user => {}
				response.should redirect_to(signin_path)
			end
		end
	
		describe "for signed in users" do
			before(:each) do
				wrong_user = Factory(:user, :email => "billg@microsoft.com")
				test_sign_in(wrong_user)
			end

			it "should require matching users for 'edit'" do
				get :edit, :id => @user
				response.should redirect_to(root_path)
			end

			it "should require matching users for 'update'" do
				put :update, :id => @user, :user => {} #empty user b/c redirecting them
				response.should redirect_to(root_path)
			end			
		end
	end
end
