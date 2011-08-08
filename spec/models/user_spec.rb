require 'spec_helper'

describe User do
  
  before(:each) do
    @default_user   = 'Example User'
    @default_email  = 'user@example.com'
    @attr_hash = {:name => @default_user, :email => @default_email}
  end
  
#  pending "add some examples to (or delete) #{__FILE__}"
  it "should create a new instance given a valid attribute" do
    User.create!(@attr_hash)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr_hash.merge(:name => ''))
    no_name_user.should_not be_valid #this calls valid? on user
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr_hash.merge(:email => ''))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = 'a'*51
    long_name_user = User.new(@attr_hash.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  # use this to debug our illegal format test! (a test for a test.... inception!)
  it "should accept valid email addresses" do
    addresses = %w[THE_USER@foo.bar.org 
                  first.last@foo.jp
                  first.middle.last@foo.kn
                  username+paypal@gmail.com
                  moo-may@gmail.com
                  name@1.2.3.com
                  a@1-2.com] 
    addresses.each do |address|
      valid_email_user = User.new(@attr_hash.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    #addresses = %w[user@foo,com THE_USER_foo.bar.org first.last_at_foo.jp example_user@foo.] 
    addresses = %w[user@foo,com 
                  THE_USER_foo.bar.org 
                  THE_USER@foo..bar.org 
                  first.last_at_foo.jp 
                  example_user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr_hash.merge(:email => address))      
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr_hash)
    duplicate_email_user = User.new(@attr_hash)
    duplicate_email_user.should_not be_valid
  end
  
  it "should reject email addresses that are identical up to case" do
    upcased_email = @attr_hash[:email].upcase
    User.create!(@attr_hash)
    
    #duplicate_email_user = User.new(@attr_hash.merge(:email => @attr_hash[:email].upcase))
    duplicate_email_user = User.new(@attr_hash.merge(:email => upcased_email))
    duplicate_email_user.should_not be_valid
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

