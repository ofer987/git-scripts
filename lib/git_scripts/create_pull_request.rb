# frozen_string_literal: true

module GitScripts
  class CreatePullRequest < PullRequest
    def execute
      GitHub.create_pull_request_url(branch)
    end

    private

    def select_pull_request
      result = gets.to_s.strip

      if %w[n new].include? result.downcase
        GitHub.create_pull_request_url(branch)
      elsif (index = result.to_i) != 0 && index >= 1 && index <= pull_requests.size
        pull_requests[result.to_i - 1].html_url
      end
    end
  end
end
