# frozen_string_literal: true

require 'active_support'
require 'octokit'
require 'rake'
require 'rest-client'
require 'uri'
require 'yaml'

require_relative 'git_scripts/version'

module GitScripts
  require_relative './git_scripts/git'
  require_relative 'git_scripts/github'
  require_relative 'git_scripts/pull_request'
  require_relative 'git_scripts/open_pull_request'
  require_relative 'git_scripts/create_pull_request'

  require_relative 'git_scripts/models/jira'

  class Error < StandardError; end
  # Your code goes here...

  class PullRequest
    def branch
      return @branch if defined? @branch

      @branch = ARGV[0] || Git.branch_name
    end

    def my_pull_requests
      return @my_pull_requests if defined? @my_pull_requests

      github = GitHub.new
      @my_pull_requests = github.my_pull_requests('origin', branch)
    end

    def execute
      throw NotImplementedError
    end

    protected

    def initialize; end
  end
end
