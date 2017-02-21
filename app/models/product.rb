class Product < ActiveRecord::Base
  validates :user_id, presence: true
  belongs_to :user
  
  def User.create_product!(product_hash = {})
    
    product_hash[:user_id] = User.find_by_session_token(session[:session_token]).id
    if Product.create!(product_hash)
      return true
    else
      return false
    end
    
  end
end
