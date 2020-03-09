class UsersController < ApplicationController
	before_action :authenticate, :only => [:edit, :update, :index, :destroy]
		#before_filter gets a function that returns true or false
		#second param (options hash) limits which actions get the filter
	before_action :correct_user, :only => [:edit, :update] 
	before_action :admin_user, :only => :destroy

  def index
	  @users = User.paginate(:page => params[:page])
	  @title = "All users"
  end

  def show
	  #@user = User.find 1				#returns the user whose ID is equal to 1
	  
	  @user = User.find(params[:id])	#params is a function that returns params from the URL
	  @microposts = @user.microposts.paginate(:page => params[:page]) 
									 #sets up pagination. needs corresponding will_paginate in the view template
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
		sign_in(@user)
		#flash[:success] = "Welcome to my Demo App" #older way to do a flash
		redirect_to @user, :flash => { :success => "Welcome to pawstwit, written in Ruby on Rails" }
			#from within controller, the above line does same as: redirect_to user_path(@user)
			#ruby just knows what to do with a naked @user
	else
		@title = "Sign up"
		render 'new'
	end
  end
  
  def edit
	  @user = User.find(params[:id])
	  @title = "Edit user"
  end
  
  def update
	  @user = User.find(params[:id])
	  if @user.update_attributes(params[:user])
		  redirect_to @user, :flash => { :success => "Updated your profile." }
		  #it worked
	  else
		  #do the fail stuff
		  @title = "Edit user"
		  render 'edit'
	  end
  end

  def destroy
	@user.destroy
	#flash[:success] = "User deleted."
	redirect_to users_path, :flash => { :success => "User dereted." }
  end

  private
    def authenticate
		deny_access unless signed_in? #deny_access() is defined in sessions_helper.rb
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end

	def admin_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless (current_user.admin? && !current_user?(@user))
		#redirect_to(root_path) if (!current_user.admin? || current_user(@user))
	end
		
end
