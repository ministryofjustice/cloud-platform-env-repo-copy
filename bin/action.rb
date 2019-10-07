#!/usr/bin/env ruby

require "json"

puts "Hello from ruby"
puts "Terraform is at..."
puts `which terraform`

event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
# puts event.inspect
puts File.read(ENV['GITHUB_EVENT_PATH'])

__END__

