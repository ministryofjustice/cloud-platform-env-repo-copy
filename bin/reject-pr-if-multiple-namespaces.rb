#!/usr/bin/env ruby

require "json"
require "octokit"

puts "hello from the PR rejecter"

data = JSON.parse File.read(ENV['GITHUB_EVENT_PATH'])

pr_number = data.dig("pull_request", "number")
puts "pr_number: #{pr_number}"

name = data.dig("repository", "name")
owner = data.dig("repository", "owner", "login")
repo = [name, owner].join("/")

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
# current_repo = Octokit::Repository.from_url(event["repository"]["html_url"])

client.create_pull_request_comment(
  repo,
  pr_number,
  "This is the body"
)

# @comment = @client.create_pull_request_comment \
#   @test_repo,
#   @pull.number,
#   new_comment[:body],
#   new_comment[:commit_id],
#   new_comment[:path],
#   new_comment[:position]
