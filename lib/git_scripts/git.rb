# frozen_string_literal: true

module GitScripts
  class Git
    PROJECT_REGEX = /([A-Za-z]-\d+)/
    DEFAULT_REMOTE = 'origin'

    def self.username
      `git config user.username`.strip
    end

    def self.remote_name(name)
      name = name.to_s.strip

      return name unless name.empty?

      `git config --get branch.#{branch_name}.remote`.chomp
    end

    def self.origin_url
      `git config remote.origin.url`.strip
    end

    def self.repo_url
      url = origin_url

      url = url.gsub(/\.git/, '') if /\.git$/.match? url

      return url if %r{^https://}.match? url

      raise "Sorry, but #{url} is not valid" unless /^git@/.match? url

      url
        .gsub(/^git@/, 'https://')
        .gsub(%r{(https://.*):(.*)/(.*)}, '\\1/\\2/\\3')
    end

    def self.github_repo
      repo_url.gsub('https://github.com/', '')
    end

    def self.branch_name
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

    def self.project_name
      Array(PROJECT_REGEX.match(branch_name))[1].to_s.capitalize
    end

    def self.repo_directory
      `git rev-parse --show-toplevel 2> /dev/null`.chomp
    end

    def self.local_file_path(absolute_file_path)
      absolute_file_path.delete_prefix(repo_directory)
    end

    def self.merge_branch_name
      `git config --get init.defaultBranch`.chomp || 'master'
    end

    def self.sorted_branches
      # `git for-each-ref --sort=-committerdate refs/heads | cut -d\t -f 2 | sed -E 's/refs\\/heads\\/(.+)$/\\1/'`
      `git for-each-ref --sort=-committerdate refs/heads`.split("\n")
        .map { |line| line.split("\t")[1] }
        .map { |value| value.gsub('refs/heads/', '') }
    end
  end
end
