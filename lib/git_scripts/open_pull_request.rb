# frozen_string_literal: true

module GitScripts
  class OpenPullRequest < PullRequest
    def execute
      return unless Array(my_pull_requests).length.positive?

      return my_pull_requests.first.html_url if my_pull_requests.size == 1

      i = 1
      my_pull_requests.each do |item|
        puts "#{i}. #{item.title}: #{item.html_url}"

        i += 1
      end

      puts 'Enter number to edit existing Pull Request'
      puts "Invalid input (enter between 1 to #{my_pull_requests.size})" while (line = select_pull_request).blank?

      puts line

      line
    end

    private

    def select_pull_request
      index = gets.to_i
      return '' if index < 1 && index > my_pull_requests.size

      my_pull_requests[index - 1].html_url
    end
  end
end
