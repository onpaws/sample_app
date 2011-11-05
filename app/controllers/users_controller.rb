class UsersController < ApplicationController
  def new
	  @title = "Sign up"
  end

  def show
	  #@user = User.find 1				#returns the user whose ID is equal to 1
	  @user = User.find(params[:id])	#params is a function that inputs params from the URL

  end
end
