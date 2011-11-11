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

  def create
	#raise params[:user].inspect
	@user = User.new(params[:user])

	if @user.save
		#handle the save
		#flash[:success] = "Welcome to my Demo App" #older way to do a flash
		redirect_to @user, :flash => { :success => "Welcome to my Rails App" }
		#identical to: redirect_to user_path(@user)
	else
		@title = "Sign up"
		render 'new'
	end
  end

end
