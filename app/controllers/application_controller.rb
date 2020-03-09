class ApplicationController < ActionController::Base
  #include sessions helper so we can use signed_in? from all controllers 
  include SessionsHelper
end
