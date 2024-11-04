# frozen_string_literal: true

module GitScripts
  class Repo
    NO_CODE_SCANNING = 'no-code-scanning'
    SNYK_AND_CICD_SCANNING = 'ddci-tr-digital-preprod'
    ARCHIVED = 'archived'

    attr_reader :owner, :name

    def initialize(owner, name)
      @owner = owner.to_s
      @name = name.to_s

      body
      @not_found = false
    rescue RestClient::NotFound
      @not_found = true
    end

    def no_code_scanning?
      topic? NO_CODE_SCANNING
    end

    def not_found?
      @not_found
    end

    def snyk_and_cicd_enabled?
      topic? SNYK_AND_CICD_SCANNING
    end

    def archived?
      return false if @not_found

      body[ARCHIVED]
    rescue RestClient::Exception
      puts "Failed to determine whether '#{self}' is archived"

      throw
    end

    def topic?(value)
      return false if @not_found

      topics = Array(body['topics'])
      topics.any? value
    rescue RestClient::Exception
      puts "Failed to determine whether '#{self}' contains the topic '#{value}'"

      throw
    end

    def to_s
      @to_s ||= "https://github.com/#{owner}/#{name}"
    end

    private

    def body
      return @body if defined? @body

      url = "https://api.github.com/repos/#{owner}/#{name}"

      credentials = Git.password
      headers = {
        'Authorization' => "Bearer #{credentials}",
        'X-GitHub-Api-Version' => '2022-11-28'
      }

      response = RestClient.get url, headers

      @body = JSON.parse(response.body)
    end
  end
end
