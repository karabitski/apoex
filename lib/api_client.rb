require 'net/http'
require 'json'

class ApiClient
  BASE_URL = "http://localhost:3000?query="
  
  def initialize(args)
    @uri = URI.parse(BASE_URL + URI.encode(args))
  end
  
  def query
    JSON.parse(response)['reg_number']  
  end
  
  def response
    http = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Get.new(@uri.request_uri)
    request['accept'] = 'application/json'
    http.request(request).body  
  end
end