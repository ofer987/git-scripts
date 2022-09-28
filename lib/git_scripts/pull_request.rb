# frozen_string_literal: true

module GitScripts
  class PullRequest
    def self.password
      ENV['GITHUB_TOKEN']
    end

    def self.username
      Git.username
    end

    def self.branch
      ARGV[1] || Git.branch_name
    end

    def self.open_pull_requests
      GitHub.new(username, password)

      github.open_pull_requests(branch)
    end

    def self.pull_requests
      github = GitHub.new(username, password)

      github.pull_requests(branch)
    end
  end
end
