class User < ActiveRecord::Base
    
  has_many :products, dependent: :destroy
  
  def User.create_user!(user_hash = {})
    if User.find_by_email(user_hash[:email])
        return false
    else
        user_hash[:session_token] = SecureRandom.base64
        User.create!(user_hash)
        return true
    end
  end
    
end
