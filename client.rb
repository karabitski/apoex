#!/usr/bin/env ruby
require File.expand_path('../lib/api_client', __FILE__)

client = ApiClient.new(ARGV.join(' '))
puts client.query