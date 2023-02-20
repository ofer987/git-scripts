# frozen_string_literal: true

module WorkItem
  class Jira < Base
    attr_reader :project, :number, :title

    def initialize(project, number, title)
      super

      @project = project.to_s.strip.upcase
      @number = number.to_i
      @title = title.to_s.strip.titlecase
    end

    def to_s
      "[#{key}] #{title}"
    end

    def url
      "https://jira.thomsonreuters.com/browse/#{key}"
    end

    def key
      @key ||= "#{project}-#{number}"
    end
  end
end
