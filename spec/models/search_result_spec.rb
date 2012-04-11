require 'spec_helper'

describe SearchResult do
  before(:each) do
    ActionController::Base.perform_caching = true
    ActionController::Base.cache_store = :file_store, "tmp/cache"
    FakeWeb.allow_net_connect = false
    @found_response     = File.read Rails.root.join("spec/assets/found.html")
  end
  
  it "do not find company using query 'no such company'" do
    query  = 'no such company'
    not_found_response = File.read(Rails.root.join("spec/assets/not_found.html"))
    FakeWeb.register_uri(:get, SearchResult::BASE_URL + URI.encode(query), :body => not_found_response, :content_type => "text/html")
    
    SearchResult.run(query).should eq(nil)
  end
  
  context "uses Rails.cache to store queries and reg.numbers" do
    before(:each) do
      @query  = 'apoex'
      @result = '556633-4149'
    end
    
    it "finds company using query 'apoex'" do
      FakeWeb.register_uri(:get, SearchResult::BASE_URL + URI.encode(@query), :body => @found_response, :content_type => "text/html")  
      SearchResult.run(@query).should eq(@result)
    end
    
    it "stores 'apoex' query in cache" do
      Rails.cache.read(@query).should eq(@result)
    end
    
    it "reads value from cache, without external requests" do
      not_found_response = File.read(Rails.root.join("spec/assets/not_found.html"))
      FakeWeb.register_uri(:get, SearchResult::BASE_URL + URI.encode(@query), :body => not_found_response, :content_type => "text/html")  
      
      SearchResult.run(@query).should eq(@result)
    end
  end
  
  after(:all) do
    ActionController::Base.perform_caching = false
    FileUtils.rm_rf(Dir['tmp/cache'])
  end
end
  