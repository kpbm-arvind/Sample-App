require 'spec_helper'

describe User do
  
  before(:each) do
    @default_user   = 'Example User'
    @default_email  = 'user@example.com'
    @default_password = 'password'
    @default_password_confirmation = 'password'
    @attr_hash = {:name => @default_user, 
                  :email => @default_email,
                  :password => @default_password,
                  :password_confirmation => @default_password_confirmation}
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
  
  describe "passwords" do
    before(:each) do
      @user = User.new(@attr_hash)
    end
    
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr_hash.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr_hash.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a"*5 #our passwords need to be 6-40chars long
      hash = @attr_hash.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a"*41 #our passwords need to be 6-40chars long
      hash = @attr_hash.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr_hash)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
    
    it "should have a salt" do
      @user.should respond_to(:salt)
    end
    
    describe "has_password? method" do
      it "should exist" do
        @user.should respond_to(:has_password?)
      end
      
      it "should return true if passwords match" do
        @user.has_password?(@attr_hash[:password]).should be_true
      end
      
      it "should return false otherwise" do
        @user.has_password?("invalid").should be_false        
      end
      
    end
    
    describe "authenticate method" do
      it "should exist" do
        #class method
        User.should respond_to(:authenticate)
      end

      it "should return nil on email/password mismatch" do
        User.authenticate(@attr_hash[:email], "wrongpass").should be_nil
      end

      it "should return nil on email with no user" do
        User.authenticate("bar@foo.com", @attr_hash[:password]).should be_nil
      end

      it "should return the actual user on a match" do
        User.authenticate(@attr_hash[:email], @attr_hash[:password]).should == @user
      end
    end
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

