#!/usr/bin/env ruby
require File.expand_path('../lib/api_client', __FILE__)

client = ApiClient.new
puts client.query