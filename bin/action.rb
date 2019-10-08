#!/usr/bin/env ruby

require "json"

puts "Hello from ruby"
puts "Terraform is at..."
puts `which terraform`
puts `which git`

# event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
# puts event.inspect
# puts File.read(ENV['GITHUB_EVENT_PATH'])

File.open("foobar", "w") { |f| f.puts("Hello from Ruby at #{Time.now}") }
system("git config --global user.email 'github-actions@digital.justice.gov.uk'")
system("git config --global user.name 'Github Actions'")
system("git add foobar")
system("git commit -m Whatever")
system("git push origin master")

__END__

