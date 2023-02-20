# frozen_string_literal: true

module WorkItem
  class ADO
    attr_reader :project, :number, :title

    def initialize(number, title)
      @number = number.to_i
      @title = title.to_s.strip.titlecase
    end

    def to_s
      "[#{key}] #{title}"
    end

    def url
      "https://dev.azure.com/tr-commercial-eng/Commercial%20Engineering/_workitems/edit/#{number}"
    end

    def key
      @key ||= "AB##{number}"
    end
  end
end
