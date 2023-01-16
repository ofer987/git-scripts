# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'
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
  require_relative 'git_scripts/work_item'

  require_relative 'git_scripts/models/jira'

  class Error < StandardError; end
  # Your code goes here...

  class PullRequest
    def branch
      return @branch if defined? @branch

      @branch = ARGV[0] || Git.branch_name
    end

    def pull_requests
      return @pull_requests if defined? @pull_requests

      github = GitHub.new
      @pull_requests = github.pull_requests(branch)
    end

    def execute
      throw NotImplementedError
    end

    protected

    def initialize; end
  end
end
