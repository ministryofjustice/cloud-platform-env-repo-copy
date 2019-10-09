#!/usr/bin/env ruby

require "json"
require "octokit"

NAMESPACE_REGEX = %r[namespaces.live-1.cloud-platform.service.justice.gov.uk]

def github_client
  unless ENV.key?("GITHUB_TOKEN")
    raise "No GITHUB_TOKEN env var found. Please make this available via the github actions workflow\nhttps://help.github.com/en/articles/virtual-environments-for-github-actions#github_token-secret"
  end

  @client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
end

def event
  unless ENV.key?("GITHUB_EVENT_PATH")
    raise "No GITHUB_EVENT_PATH env var found. This script is designed to run via github actions, which will provide the github event via this env var."
  end

  @evt ||= JSON.parse File.read(ENV["GITHUB_EVENT_PATH"])
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
  puts "Requesting changes..."
  puts message

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

def namespaces_touched_by_pr
  github_client.pull_request_files(repo, pr_number)
    .map(&:filename)
    .grep(NAMESPACE_REGEX)
    .map { |f| File.dirname(f) }
    .map { |f| f.split("/") }
    .map { |arr| arr[2] }
    .sort
    .uniq
end

############################################################

namespaces = namespaces_touched_by_pr

# PRs which touch no namespaces are fine
# PRs which touch one namespace are fine
if namespaces.size > 1
  namespace_list = namespaces.map {|n| "  * #{n}"}.join("\n")
  message = <<~EOF
  This PR affects multiple namespaces

  #{namespace_list}

  Please submit a separate PR for each namespace.

  EOF
  reject_pr(message)
end
