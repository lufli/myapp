class SessionsController < ApplicationController
    
  def user_params
    params.require(:session).permit(:email, :password)
  end
    
  def new
    render 'new'
  end
  
  def create
    if user_params[:email] == ""
      flash[:warning] = "You have to type your username."
      redirect_to new_user_path
      return
    elsif user_params[:password] == ""
      flash[:warning] = "You have to type your password."
      redirect_to new_user_path
      return
    end
    
    user = User.find_by_email(user_params[:email])
    if user and user.password==user_params[:password]
      session[:session_token] = user.session_token
      flash[:success] = "You are login as #{user.email}!"
      redirect_to root_path
      return
    else
      flash[:warning] = "The username and password you entered did not match our records."
      redirect_to new_user_path
      return
    end
  end
  
  def destroy
      reset_session
      redirect_to root_path
  end
end