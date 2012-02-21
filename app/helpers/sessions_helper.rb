module SessionsHelper
	#put the sign_in function here since rails auto-generated it
	#old rails 2.3 way of doing this was:
	#cookies[:remember_token] = { :value => user.id, :expires => 20.years.from_now.utc }
	
	#once you set the token, you can find the user by the token
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt] #sets cookie only
		self.current_user = user
	end

	def current_user=(user)		#this is a setter method
		@current_user = user
	end
	
	def current_user
		#instance variables only exist for one page request - we can't simply return @current_user here
		@current_user ||= user_from_remember_token
					   #if we use current_user more than once, it saves us a database hit
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		#current_user = nil		#some people report self. being necessary
		self.current_user = nil
	end

	def current_user?(user)
		user == current_user
	end

	def authenticate #copied from users_controller per lesson 11 manipulating microposts @ 7:15
		deny_access unless signed_in? #deny_access() is defined in sessions_helper.rb
	end

	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end
	
	def store_location
		session[:return_to] = request.fullpath
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
					#access a hash key with no value is Nil
		clear_return_to
					#stops user from going to edit page every sign in
	end

	def clear_return_to
		session[:return_to] = nil
	end

	private
		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
										# the * 'unwraps' the array
		end
		
		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end
end
