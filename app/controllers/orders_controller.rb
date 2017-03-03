class OrdersController < ApplicationController
    
  def order_params
    params.require(:order).permit(:product_id, :user_id, :quantity, :total, :details, :address)
  end
  
  def create
    hash = order_params
    hash[:total] = Product.find(order_params[:product_id]).price*order_params[:quantity].to_f
    if Order.create!(hash) then
      flash[:notice] = "Thank you for order in MyChef!"
    else
      flash[:notice] = "Something goes wrong."
    end
    redirect_to myorder_path
  end
  
  def show
    @orders = {}
    id = User.find_by_session_token(session[:session_token]).id
    Order.where(:user_id => id).collect.each do |order|
      @orders[order] = Product.find(order.product_id)
      @orders.sort_by { |k, v| k[:created_at] }
      @orders = Hash[@orders.to_a.reverse]
    end
    if !@orders then
      flash[:notice] = "You have no order, make one."
    end
    render 'show'
  end
  
  def detail
    @order = Order.find_by_id(params[:id])
    @product = Product.find_by_id(@order.product_id)
    @seller = User.find_by_id(@product.user_id)
    render 'detail'
  end
end