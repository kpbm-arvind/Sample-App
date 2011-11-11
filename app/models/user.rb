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
#

