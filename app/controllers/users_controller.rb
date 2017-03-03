class UsersController < ApplicationController

  def user_params
    params.require(:user).permit(:email, :password, :confirmation, :address1, :address2, :city, :state, :zipcode)
  end

  def new
    if @current_user then
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def profile
    @user = User.find_by_session_token(session[:session_token])
    if @user
      render 'profile'
    else
      redirect_to new_user_path
    end
  end
  
  def update
    @user = User.find_by_session_token(session[:session_token])
    if @user.update(user_params)
      flash[:success] = "Successfully updated!"
    else
      flash[:notice] = "Failed to update. Please try again."
    end
    
    redirect_to profile_path
  end
  
  def create
    
    if user_params[:password] != user_params[:confirmation] then
      flash[:notice] = "Your password do not match. Please try again."
    else   
      hash = user_params
      if User.create_user!({:email => hash[:email], :password => hash[:password]}) then
        flash[:success] = "You have successfully signed up. Please sign in."
      else
        flash[:notice] = "This user name has already been taken. Please try another one."
      end
    end
    
    redirect_to new_user_path
  end

end