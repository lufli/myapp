class ProductsController < ApplicationController
  
  def product_params
    params.require(:product).permit(:name, :price, :description, :image, :address, :distance)
  end
  
  def new
    render 'new'
  end
  
  def create
    product_params[:user_id] = User.find_by_session_token(session[:session_token]).id.to_i
    hash = product_params
    hash[:user_id] = User.find_by_session_token(session[:session_token]).id.to_i
    if Product.create!(hash) then
      flash.now[:notice] = "You have successfully create a work. Well done!"
    else
      flash.now[:notice] = "Something goes wrong."
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
        flash.now[:warning] = "You need type your address to get the distance!"
    else
      @products = {}
      user_geocode = Geocoder.coordinates(product_params[:address])
        Product.all.each do |product|
          seller = User.find_by_id(product.user_id)
          seller_address = seller.address1 + ', ' + seller.city + ', ' + seller.state
          seller_geocode = Geocoder.coordinates(seller_address)
          distance = Geocoder::Calculations.distance_between(user_geocode, seller_geocode)
          if distance<=product_params[:distance].to_f then
            @products[product] = distance.round(1)
            # @products.append(product)
            # distances.appdend(distance)
          end
        end
      flash[:success] = @products.size.to_s + " food have been found in your area."
    end
    render 'show'
  end
  
  def detail
    flash.now[:info] = "Before making an order, make sure you can pick up at the address shows below."
    @product = Product.find_by_id(params[:id])
    @user = User.find_by_id(@product.user_id)
    @id = User.find_by_session_token(session[:session_token]).id.to_i
    render 'detail'
  end
  
end