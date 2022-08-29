# frozen_string_literal: true

module GitScripts
  class GitHub
    REGEX = %r{github\.com[/:](.*)\.git\b}

    def self.github_repos
      repos = `git remote -v`.chomp.split("\n")

      repos
        .map { |item| Array(REGEX.match(item)) }
        .filter { |item| item.size >= 2 }
        .map { |item| item[1] }
        .uniq
    end

    def self.create_pull_request_url(branch_name)
      "https://github.com/#{GitHub.github_repos.first}/compare/#{Git.merge_branch_name}...#{branch_name}"
    end

    def initialize
      @username = Git.username
      @password = Git.password

      @client = Octokit::Client.new(
        login: @username,
        password: @password
      )
    end

    def my_pull_requests(branch_name)
      results = GitHub.github_repos.flat_map do |item|
        @client.pull_requests(item, state: 'open')
      end

      results
        .select { |item| item.head.ref == branch_name }
        .sort_by(&:updated_at)
        .reverse
    end

    def open_pull_requests
      # Add paging
      # page: i, per_page: max_page_count
      results = GitHub.github_repos.flat_map do |item|
        @client.pull_requests(item, state: 'open')
      end

      # binding.pry

      results
        .sort_by(&:updated_at)
        .reverse
    end

    def jira_ids
      open_pull_requests
        .map(&:title)
        .map(&:to_s)
        .map { |title| Models::Jira.init_from_github_title(title) }
        .reject(&:nil?)
        .sort
        .uniq(&:title)
    end
  end
end
