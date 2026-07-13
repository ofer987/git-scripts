# frozen_string_literal: true

module WorkItem
  class ADO < Base
    attr_reader :project, :number, :title

    def initialize(number, title)
      super(number.to_i, title)
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
