Factory.define :user do |user|
	user.name						"Me User"
	user.email						"me@example.com"
	user.password					"foobar"
	user.password_confirmation		"foobar"
end

Factory.sequence :email do |n|
	"person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
	micropost.content				"Bork the borking bork, chef!"
	micropost.association			:user
			 #association lets us use the object in the spec. i.e.
			 #:user => @user instead of user_id => @user.user_id
end
