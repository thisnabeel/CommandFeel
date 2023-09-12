class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]
  has_many :attempts

  def generate_temporary_authentication_token
    # self.authentication_token = Devise.friendly_token
    token = Devise.friendly_token
    tokens = (self.tokens || []).push(token)
    begin
      self.update(tokens: tokens)
    rescue => exception
      puts exception
    end
    return token
  end

  def clear_temporary_authentication_token
    self.authentication_token = nil
    self.save
  end

  def admin?
  	array = ["farhanmshaikh@hotmail.com", "rockystorm@gmail.com"]
  	bool = false
  	array.each do |a|
	  	if self.email.include? a
	  		return true
	  	else
	  	end
  	end
  	return bool
  end

  def User.is_admin? (user)
    if !user.present?
      bool = false
    else
      array = ["farhanmshaikh@hotmail.com", "rockystorm@gmail.com"]
      bool = false
      array.each do |a|
        if user.email.include? a
          return true
        else
        end
      end
    end
    return bool
  end


  def login
    @login || self.username || self.email
  end
end
