# frozen_string_literal: true

module GitScripts
  class PullRequest
    def password
      ENV['GITHUB_TOKEN']
    end

    def username
      return @username if defined? @username

      @username = Git.username
    end

    def branch
      return @branch if defined? @branch

      @branch = ARGV[0] || Git.branch_name
    end

    def my_pull_requests
      return @my_pull_requests if defined? @my_pull_requests

      github = GitHub.new(username, password)
      @my_pull_requests = github.my_pull_requests(branch)
    end

    def execute
      throw NotImplementedError
    end

    protected

    def initialize; end
  end
end
