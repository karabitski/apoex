require 'net/http'
require 'json'

class ApiClient
  BASE_URL = "http://localhost:3001?query="
  
  def initialize(args = ARGV.join(' '))
    @query = URI.encode args
  end
  
  def query
    JSON.parse(response.body)['reg_number']  
  end
  
  def response
    uri = URI.parse(BASE_URL + @query)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['accept'] = 'application/json'
    http.request(request)  
  end
end