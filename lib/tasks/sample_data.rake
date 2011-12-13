require 'faker'

namespace :db do
	desc 'Fill database with sample data'
	task :populate => :environment do
		Rake::Task['db:reset'].invoke #runs rake db:reset to clear database
		User.create!(:name => "Example User", 
					 :email => "example@e.org",
					 :password => "foobar", 
					 :password_confirmation => "foobar")
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "boring"
			User.create!(:name => name, 
						:email => email,
						:password => password,
						:password_confirmation => password)
		end
	end
end
