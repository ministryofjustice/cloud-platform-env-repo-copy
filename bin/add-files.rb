#!/usr/bin/env ruby

require "json"
require "octokit"
require "pry-byebug"

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

def commit_files(branch, files, commit_message)
  changes = files.map { |f| commit_change(f) }
  binding.pry ; 1


  t = get_tree(branch)
  sha_latest_commit = t.fetch(:latest_commit)
  sha_new_tree = t.fetch(:tree)
  ref = t.fetch(:ref)

  github.create_tree(repo, changes, { base_tree: sha_new_tree })
  sha_new_commit = github.create_commit(repo, commit_message, sha_new_tree, sha_latest_commit).sha
  github.update_ref(repo, ref, sha_new_commit)
end

def get_tree(branch)
  ref = "heads/#{branch}"
  latest_commit = github.ref(repo, ref).object.sha
  tree = github.commit(repo, latest_commit).commit.tree.sha
  { latest_commit: latest_commit, tree: tree, ref: ref }
end

def commit_change(file_name)
  content = File.read(file_name)
  blob_sha = github.create_blob(repo, Base64.encode64(content), "base64")
  {
    path: file_name,
    mode: "100644",
    type: "blob",
    sha: blob_sha
  }
end

############################################################

puts "PR: #{pr_number}"
puts "branch: #{branch}"
puts "repo: #{repo}"

commit_files(
  "commit-a-file",
  ["bad-pr.sh", "raise-pr.sh"],
  "More files"
)
