class UsersController < ApplicationController
  def show
	  #@user = User.find 1				#returns the user whose ID is equal to 1
	  
	  @user = User.find(params[:id])	#params is a function that returns params from the URL
	  @title = @user.name
  end

  def new
	  @title = "Sign up"
	  @user = User.new					#save the params hash for the create function, not here
  end
end
