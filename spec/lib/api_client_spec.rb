require 'spec_helper'
require File.expand_path('lib/api_client', Rails.root)

describe ApiClient do
  before(:each) do
    @query = 'apoex'
    @result = '556633-4149'
    @client = ApiClient.new(@query)
  end
  
  it "initializes using query string" do
    uri = @client.instance_variable_get(:@uri)
    request_uri = "/?" + ApiClient::BASE_URL.split('?').last
    host, port = ApiClient::BASE_URL.split('?').first.gsub(/(http|https):\/\//, '').split(':')
    uri.host.should eq(host)
    uri.port.should eq(port ? port.to_i : 80)
    uri.request_uri.should eq(request_uri + @query)
  end
  
  it "returns reg number of found company" do
    @client.stub(:response).and_return("{\"success\": true, \"reg_number\": \"#{@result}\"}")
    @client.query.should eq(@result)  
  end
  
  it "returns 'Not found' when no company found" do
    @client.stub(:response).and_return("{\"success\": true, \"reg_number\": \"Not found\"}")
    @client.query.should eq('Not found')
  end
  
end
