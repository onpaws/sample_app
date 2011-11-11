class SessionsController < ApplicationController
  def new
	  @title = "Sign in"
  end
  
  def create
	  user = User.authenticate(params[:session][:email],
							   params[:session][:password])
	  if user.nil?
		flash.now[:error] = "Invalid logon"
		@title = "Sign in"
		render "new"
	  else
		# successful signin, log em in!
	end
  end
  
  def destroy
  end

end
