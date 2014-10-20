class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  before_filter :check_count
  
  helper_method :login_user, :login_user_id
  
  def check_count
      require 'redis/counter'
      app_token = Redis::Counter.new("test")
      app_token.increment
  end

  def login_user_id
    session[:user_id]
  end
  
  def login_user
    @login_user ||= User.active.where(id: login_user_id).first
  end
  
  def login_with_all
    redirect_to("/") unless login_user_id
  end

    
end
