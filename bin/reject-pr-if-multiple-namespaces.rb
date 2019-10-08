#!/usr/bin/env ruby

require "json"
require "octokit"

# TODO: how to display an informative failure message?
# TODO: give the action a name that displays in the workflow
# TODO: allow PRs that don't touch the namespaces folder(s)
# TODO: allow PRs that only touch one namespace folder
# TODO: replace the default icon for the bot

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

puts "token: #{ENV['GITHUB_TOKEN']}"

# PRs which touch no namespaces are fine
# PRs which touch one namespace are fine
# reject_pr("You shall not pass.") if number_of_namespaces > 1
