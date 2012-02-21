namespace :db do
	desc 'Fill database with sample data'
	task :populate => :environment do
		require 'faker'
		Rake::Task['db:reset'].invoke #runs rake db:reset to clear database
		admin = User.create!(:name => "Example User", 
					 :email => "billg@microsoft.com",
					 :password => "asdfasdf", 
					 :password_confirmation => "asdfasdf") 
					 # putting :admin => "true" requires declaration in user.rb:attr_accessible
					 # which we don't do, since it undermines security
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "boring"
			User.create!(:name => name, 
						:email => email,
						:password => password,
						:password_confirmation => password)
		end

		User.all(:limit => 6).each do |user| 
			50.times do 
				user.microposts.create!(:content => Faker::Lorem.sentence(5))
				#TODO: why is it user.microposts and not user.micropost?
			end
		end
	end
end
