class User < ActiveRecord::Base
  attr_accessor   :password #in memory! not in DB
  
  attr_accessible :name
  attr_accessible :email
  attr_accessible :password
  attr_accessible :password_confirmation

  email_regex = /\A[a-z0-9._%+-]+@(?:[a-z0-9-]+\.)+[a-z]{2,4}\z/i

  validates       :name,    :presence   =>  true, 
                            :length     =>  {:maximum => 50}
                          
  validates       :email,   :presence   =>  true,
                            :format     =>  {:with => email_regex},
                            :uniqueness =>  {:case_sensitive => false}
                  
  # password validations                        
  validates       :password,:presence => true,
                            :confirmation => true, # this creates an attribute with <validating identity>_confirmation
                            :length => {:within => 6..40}
                            
  #registering a call-back
  before_save :encrypt_password
  
  class << self #how to define a bunch of class methods
    def authenticate(email, submitted_password)
      user = self.find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
    end
  end
  
  def has_password?(submitted_password)
    encrypt(submitted_password) == self.encrypted_password
  end
  
  private 
    #call-back for encrypting password before save!
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end
    
    def encrypt(string)
      secure_hash("#{self.salt}--#{string}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    def make_salt
      Digest::SHA2.hexdigest("#{Time.now.utc}--#{self.password}")
    end
      
end


# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

