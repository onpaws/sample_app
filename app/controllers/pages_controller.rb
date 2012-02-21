class PagesController < ApplicationController
  def home
	  @title = 'Home'
	  @micropost = Micropost.new if signed_in?
  end

  def about
	  @title = 'About'
  end

  def contact
	  @title = 'Contact'
  end

  def help
	  @title = 'Help'
  end
end
