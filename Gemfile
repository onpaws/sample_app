source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'pg'			#for heroku
gem 'json'

group :development do
	gem 'rspec-rails'
	#gem 'annotate'
	gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end

group :test do
	gem 'rspec'
	gem 'spork'
	gem 'webrat'
end

#from Heroku http://devcenter.heroku.com/articles/how-do-i-use-sqlite3-for-development
group :production do 
	gem 'pg'
end

# Rails 3.1 introduced a new 'asset pipeline'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

