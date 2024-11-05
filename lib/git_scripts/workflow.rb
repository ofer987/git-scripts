# frozen_string_literal: true

require_relative './workflow/failure'

module GitScripts
  class Workflow
    attr_reader :owner, :repository, :workflow_id, :branch

    def initialize(owner, repository, workflow_id, branch)
      @owner = owner
      @repository = repository
      @workflow_id = workflow_id
      @branch = branch
    end

    def recent_runs
      branch = "&branch=#{branch}" unless branch.blank?

      url = "https://api.github.com/repos/#{owner}/#{repository}/actions/workflows/#{workflow_id}/runs?per_page=3#{branch}"
      headers = {
        'Accept' => 'application/vnd.github+json',
        'Authorization' => "Bearer #{Git.password}",
        'X-GitHub-Api-Version' => '2022-11-28'
      }

      response = RestClient.get url, headers
      message = JSON.parse(response.body)['workflow_runs']

      failed_runs(message)
    rescue RestClient::Exception => e
      puts "#{self} failed because of #{e}"

      []
    end

    def to_s
      "Execution #{workflow_id} for repository #{owner}/#{repository}"
    end

    private

    def failed_runs(message)
      failures = message
        .reject { |item| item['status'] == 'in_progress' }
        .reject { |item| item['status'] == 'queued' }
        .reject do |item|
          item['status'] == 'completed' && (item['conclusion'] == 'success' || item['conclusion'] == 'cancelled')
        end

      failures.map do |item|
        Failure.new(self, item['head_branch'], item['status'], item['conclusion'], item['run_started_at'])
      end
    end
  end
end
