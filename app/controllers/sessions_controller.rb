class SessionsController < ApplicationController
  def new
	  @title = "Sign in"
  end
  
  def create
	  user = User.authenticate(params[:session][:email],
							   params[:session][:password])
	  if user.nil?
		flash.now[:error] = "I'm afraid that logon was slightly invalid."
		@title = "Sign in"
		render "new"		#render the 'new' page
	  else
		sign_in user
		#redirect_to user
		redirect_back_or user
	  end
  end
  
  def destroy
	  sign_out
	  redirect_to(root_path)
  end
end
