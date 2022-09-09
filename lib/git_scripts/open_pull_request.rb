# frozen_string_literal: true

module GitScripts
  class OpenPullRequest < PullRequest
    def execute
      return unless Array(pull_requests).length.positive?

      return pull_requests.first.html_url if pull_requests.size == 1

      i = 1
      pull_requests.each do |item|
        puts "#{i}. #{item.title}: #{item.html_url}"

        i += 1
      end

      puts 'Enter number to edit existing Pull Request'
      puts "Invalid input (enter between 1 to #{pull_requests.size})" while (line = select_pull_request).blank?

      puts line

      line
    end

    private

    def select_pull_request
      index = gets.to_i
      return '' if index < 1 && index > pull_requests.size

      pull_requests[index - 1].html_url
    end
  end
end
