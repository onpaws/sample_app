class ApplicationController < ActionController::Base
  protect_from_forgery

  #include sessions helper so we can use signed_in? from all controllers 
  include SessionsHelper
end
