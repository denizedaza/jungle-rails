class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 5}
  validates :password_confirmation, presence: true 
  validates :firstname, presence: true
  validates :lastname, presence: true

  def self.authenticate_with_credentials(email, password)
    email = email.strip.downcase
    user = User.find_by_email(email)

    #if user exists and password is correct
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end
