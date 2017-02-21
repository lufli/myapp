class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_current_user
  
  def set_current_user
    @current_user ||= session[:session_token ] && User.find_by_session_token(session[:session_token])
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  def index
    render 'index'
  end
end
