require 'spec_helper'

describe ApiController do
  before(:each) do
    FakeWeb.allow_net_connect = false
    @found_response = File.read Rails.root.join("spec/assets/found.html")
    @query  = 'apoex'
    @result = '556633-4149'
  end
  
  describe "GET index" do
    it "renders the search template" do
      get :search
      response.should render_template("search")
    end
    
    it "renders the search template with query" do
      FakeWeb.register_uri(:get, SearchResult::BASE_URL + URI.encode(@query), :body => @found_response, :content_type => "text/html")  
      get :search, :query => @query
      assigns(:reg_number).should eq(@result)
      response.should render_template("search")
    end
    
    it "renders JSON answer" do
      FakeWeb.register_uri(:get, SearchResult::BASE_URL + URI.encode(@query), :body => @found_response, :content_type => "text/html")  
      get :search, :query => @query, :format => :json
      resp = JSON.parse(response.body)
      resp['reg_number'].should eq(@result)
    end
    
    it "renders XML answer" do
      FakeWeb.register_uri(:get, SearchResult::BASE_URL + URI.encode(@query), :body => @found_response, :content_type => "text/html")  
      get :search, :query => @query, :format => :xml
      resp = Hash.from_xml(response.body)
      resp['result']['reg_number'].should eq(@result)
    end
  end
end