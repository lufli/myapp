class ProductsController < ApplicationController
  
  def product_params
    params.require(:product).permit(:name, :price, :description, :address, :distance)
  end
  
  def new
    render 'new'
  end
  
  def create
    product_params[:user_id] = User.find_by_session_token(session[:session_token]).id.to_i
    hash = product_params
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
    
    if(product_params[:distance]=='Any' or product_params[:address]=="") then
      @products = Product.all
    else
      @products = []
      user_geocode = Geocoder.coordinates(product_params[:address])
        Product.all.each do |product|
          seller = User.find_by_id(product.user_id)
          seller_address = seller.address1 + ', ' + seller.city + ', ' + seller.state
          seller_geocode = Geocoder.coordinates(seller_address)
          if Geocoder::Calculations.distance_between(user_geocode, seller_geocode)<=product_params[:distance].to_f then
            @products.append(product)
          end
        end
    end
    render 'mywork'
  end
  
end