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

    def initialize(options)
      if !options.blank?
        @client = Octokit::Client.new(options)
      else
        @username = Git.username
        @password = Git.password

        @client = Octokit::Client.new(
          login: @username,
          password: @password
        )
      end
    end

    def my_pull_requests(remote, branch_name)
      @client.pull_requests(remote, state: 'open')

      results
        .select { |item| item.head.ref == branch_name }
        .sort_by(&:updated_at)
        .reverse
    end

    def merged_pull_requests(remote, jira_key, options = {})
      results = []
      max_pages = options[max_pages] || 2
      max_page_count = options[max_page_count] || 100

      max_pages.times.each do |page|
        page += 1

        i = 1
        # binding.pry
        @client.pull_requests(remote, state: 'closed', page:, per_page: max_page_count)
          .each do |pull_request|
            if pull_request.base.ref == 'develop' &&
               pull_request.title.match?(/#{jira_key}/i) &&
               @client.pull_request_merged?(remote, pull_request.number)
              results << pull_request
            end
          end
      end

      results
    end

    def jira_keys(remote)
      merged_pull_requests(remote)
        .map(&:title)
        .map(&:to_s)
        .map { |title| Models::Jira.init_from_github_title(title) }
        .reject(&:nil?)
        .sort
        .uniq(&:key)
    end

    def create_pull_request(repo, base, head, key, body)
      @client.create_pull_request(repo, base, head, key, body)
    end
  end
end
