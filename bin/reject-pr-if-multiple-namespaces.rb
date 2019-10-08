#!/usr/bin/env ruby

require "json"
require "octokit"

def github_client
  unless ENV.has_key?("GITHUB_TOKEN")
    raise "No GITHUB_TOKEN env. var. found. Please make this available via the github actions workflow\nhttps://help.github.com/en/articles/virtual-environments-for-github-actions#github_token-secret"
  end

  @client ||= Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
end

def event
  @evt ||= JSON.parse File.read(ENV['GITHUB_EVENT_PATH'])
end

def repo
  name = event.dig("repository", "name")
  owner = event.dig("repository", "owner", "login")
  [owner, name].join("/")
end

def pr_number
  event.dig("pull_request", "number")
end

def reject_pr(message)
  github_client.create_pull_request_review(
    repo,
    pr_number,
    {
      body: message,
      event: "REQUEST_CHANGES",
    }
  )
  exit 1
end

reject_pr("You shall not pass.")
