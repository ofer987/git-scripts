# frozen_string_literal: true

module WorkItem
  class RITM < Base
    attr_reader :number, :title

    def initialize(number, title)
      super

      @number = number.to_i
      @title = title.to_s.strip.titlecase
    end

    def to_s
      "[#{key}] #{title}"
    end

    def url
      # TODO: Change to ServiceNow URL
      "https://thomsonreuters.service-now.com/sp?id=choose_catalog#{key}"
    end

    def key
      @key ||= "RITM-#{number}"
    end
  end
end
