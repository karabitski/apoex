#!/usr/bin/env ruby
require 'net/http'
require 'json'

BASE_URL = "http://localhost:3001?query="

uri = URI.parse(BASE_URL + URI.encode(ARGV.join(' ')))
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request['accept'] = 'application/json'
response = http.request(request)
reg_number = JSON.parse(response.body)['reg_number']

puts reg_number