class ProductsController < ApplicationController
  
  def user_params
    params.require(:product).permit(:name, :price, :description)
  end
  
  def new
    render 'new'
  end
  
  def create
    user_params[:user_id] = User.find_by_session_token(session[:session_token]).id.to_i
    hash = user_params
    hash[:user_id] = User.find_by_session_token(session[:session_token]).id.to_i
    if Product.create!(hash) then
      flash[:notice] = "You have successfully create a work. Well done!"
    else
      flash[:notice] = "Something goes wrong."
    end
    redirect_to mywork_path
  end
  
  def mywork
    id = User.find_by_session_token(session[:session_token]).id.to_i
    @products = Product.where(:user_id => id).collect
  end
  
  def search
    
  end
  
end