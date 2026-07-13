# frozen_string_literal: true

module WorkItem
  class Nil < Base
    def initialize(title)
      super(0, title)
    end

    def url
      ''
    end

    def key
      @key ||= title
    end

    def blank?
      false
    end

    def nil?
      false
    end

    def to_s
      @title
    end
  end
end
