# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'
require 'json'
require 'octokit'
require 'rake'
require 'rest-client'
require 'uri'
require 'yaml'

require_relative 'git_scripts/version'

def environment_variable(name)
  result = ENV[name].to_s.strip

  return result unless result.blank?

  puts "The #{name} environment variable is missing"
  exit 1
end

module GitScripts
  require_relative 'git_scripts/git'
  require_relative 'git_scripts/github'
  require_relative 'git_scripts/pull_request'
  require_relative 'git_scripts/open_pull_request'
  require_relative 'git_scripts/create_pull_request'
  require_relative 'git_scripts/work_item'

  require_relative 'git_scripts/models/jira'

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
      raise NotImplementedError
    end

    protected

    def initialize; end
  end
end
