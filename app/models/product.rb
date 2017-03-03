class Product < ActiveRecord::Base
  validates :user_id, presence: true
  belongs_to :user
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  
  def User.create_product!(product_hash = {})
    
    product_hash[:user_id] = User.find_by_session_token(session[:session_token]).id
    if Product.create!(product_hash)
      return true
    else
      return false
    end
    
  end
end
