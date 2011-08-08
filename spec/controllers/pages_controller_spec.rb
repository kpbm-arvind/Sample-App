require 'spec_helper'

describe PagesController do
  render_views
  # this code will be executed and included with each describe statement
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  # HTTP request
  describe "GET 'home'" do
    
    it "should be successful" do
      # issues a get request
      get 'home'
      
      response.should be_success
    end
    
    it  "should have the right title" do
      get 'home'
      
      response.should have_selector("title",
                                    :content => "#{@base_title} | Home")
    end
    
    it "should have a non-blank body" do
      get 'home'
      # response.body isn't the <body> tag, it's in fact the entire response
      response.body.should_not  =~ /<body>\s*<\/body>/
    end
    
  end

  describe "GET 'contact'" do
    
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it  "should have the right title" do
      get 'contact'
      
      response.should have_selector("title",
                                    :content => "#{@base_title} | Contact")
    end
    
  end
  
  describe "GET 'about'" do
    
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it  "should have the right title" do
      get 'about'
      
      response.should have_selector("title",
                                    :content => "#{@base_title} | About")
    end
    
    describe "GET 'help'" do

      it "should be successful" do
        get 'help'
        response.should be_success
      end

      it  "should have the right title" do
        get 'help'

        response.should have_selector("title",
                                      :content => "#{@base_title} | Help")
      end
    end
    
  end

end
