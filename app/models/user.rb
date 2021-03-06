# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

class User < ActiveRecord::Base
	#a virtual attribute for the password. makes a getter and setter.
	attr_accessor :password

	has_many :microposts, :dependent => :destroy
						   #if you delete a user, it deletes its corresponding microposts
						   #see Lesson 11:User microposts @ 26:00

	#register a callback so the encrypted password attribute is created before the user is saved
	before_save :encrypt_password		#apparently this symbol (:encrypted_password) refers to a function. hm.



	#define a email validator regex
	#see http://ruby.railstutorial.org/chapters/modeling-and-viewing-users-one#table:email_regex
	#\A is beginning of string, \z is end, /i insensitive
	valid_email = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	

	#syntax new to rails 3.1
	validates :name, :presence => true,
						:length => { :maximum => 64 }

	validates :email, :presence => true,
						:format => { :with => valid_email },
						#format checks against the regex
						:uniqueness => { :case_sensitive => false }
						#uniquess being true is implicit
						#warning: this on its own DOES NOT guarantee uniqueness. use an index 
	
	validates :password, :presence => true,
						 :confirmation => true,
						 #:confirmation in a validates statement adds an "_confirmation" virtual attribute
						 :length => { :within => 6..64 }
						 #:length => { :minimum => 6, :maximum => 64 } also works
	def feed
		#Micropost.all				#returns all microposts across users
		#self.microposts			#unless we are assigning to it we can leave off self.
		Micropost.where("user_id = ?", id) #question mark ensures whatever comes after is automatically escaped
	end


	def has_password?(submitted_password)
		self.encrypted_password == encrypt(submitted_password)
		#technically, we don't need self. since there is no assignment.
	end

	def User.authenticate(email, submitted_password)
		#User.authenticate means its a CLASS METHOD (as opposed to just authenticate())
		user = self.find_by_email(email)
			   #can omit self since its a class method
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

	def User.authenticate_with_salt(id, cookie_salt)
		user = User.find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
		#if user returns true AND user.salt matches the cookie salt, return the user object
	end

	#encrypt_password is only needed within the User object, so we make it private
	private
		def encrypt_password
			self.salt = make_salt if new_record?
									 #ActiveRecord method that does what the tin says
			
			self.encrypted_password = encrypt(self.password)
											  #access password attribute for this user
			#if you say self.encrypted_password ruby knows you mean the local password variable
		end

		def encrypt(string)
			secure_hash("#{self.salt}--#{string}")
						#attribute corresponding to that user
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
end
