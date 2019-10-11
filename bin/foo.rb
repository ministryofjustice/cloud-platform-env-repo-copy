#!/usr/bin/env ruby

require "json"
require "octokit"

def github
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

def branch
  event.dig("pull_request", "head", "ref")
end

############################################################

puts "PR: #{pr_number}"
puts "branch: #{branch}"
puts "repo: #{repo}"

ref = "heads/master"

sha_latest_commit = github.ref(repo, ref).object.sha

puts sha_latest_commit

sha_base_tree = github.commit(repo, sha_latest_commit).commit.tree.sha

puts sha_base_tree

file_name = File.join("bin", "bot-created-file.txt")
blob_sha = github.create_blob(repo, Base64.encode64("this is a test"), "base64")

sha_new_tree = github.create_tree(repo,
                                  [ { :path => file_name,
                                      :mode => "100644",
                                      :type => "blob",
                                      :sha => blob_sha } ],
                                      {:base_tree => sha_base_tree }).sha

commit_message = "Committed via Octokit!"
sha_new_commit = github.create_commit(repo, commit_message, sha_new_tree, sha_latest_commit).sha
updated_ref = github.update_ref(repo, ref, sha_new_commit)
puts updated_ref
