#!/usr/bin/env ruby

require "json"
require "octokit"

puts "hello from the PR rejecter"

data = JSON.parse File.read(ENV['GITHUB_EVENT_PATH'])

pr_number = data.dig("pull_request", "number")
puts "pr_number: #{pr_number}"

# client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
# current_repo = Octokit::Repository.from_url(event["repository"]["html_url"])

