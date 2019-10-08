#!/usr/bin/env ruby

require "json"
require "octokit"

puts "hello from the PR rejecter"

puts File.read(ENV['GITHUB_EVENT_PATH'])

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
current_repo = Octokit::Repository.from_url(event["repository"]["html_url"])

