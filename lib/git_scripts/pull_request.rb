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
      ARGV[0] || Git.branch_name
    end

    def self.open_pull_requests
      GitHub.new(username, password)

      github.open_pull_requests(branch)
    end

    def self.my_pull_requests
      github = GitHub.new(username, password)

      github.my_pull_requests('origin', branch)
    end
  end
end
