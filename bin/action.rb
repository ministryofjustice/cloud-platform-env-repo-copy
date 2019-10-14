#!/usr/bin/env ruby

require "json"
require "octokit"

        puts "Hello from ruby"
        puts "Terraform is at..."
        puts `which terraform`
        puts `which git`

# puts File.read(".git/config")

pp ENV

token = ENV["GITHUB_TOKEN"]
puts "token: #{token}"

event = JSON.parse(File.read(ENV["GITHUB_EVENT_PATH"]))
# puts event.inspect
# puts File.read(ENV['GITHUB_EVENT_PATH'])

# client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
# current_repo = Octokit::Repository.from_url(event["repository"]["html_url"])
# last_commit = client.commits(current_repo).last
# client.create_commit(current_repo, "My commit message", last_commit.commit.tree.sha, last_commit.sha)

# File.open("foobar", "w") { |f| f.puts("Hello from Ruby at #{Time.now}") }
# system("git config --global user.email 'github-actions@digital.justice.gov.uk'")
# system("git config --global user.name 'Github Actions'")
# system("git checkout -b master")
# system("git add foobar")
# system("git commit -m Whatever")
# system("git push -u origin master")

__END__

