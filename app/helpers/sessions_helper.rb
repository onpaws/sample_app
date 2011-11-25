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

	private
		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
										# the * 'unwraps' the array
		end
		
		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end
end
