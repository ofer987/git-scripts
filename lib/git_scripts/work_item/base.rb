# frozen_string_literal: true

module WorkItem
  class Base
    attr_reader :number, :title

    def initialize(*args); end

    def to_h
      {
        title:,
        key:,
        url:
      }
    end

    def to_s
      ''
    end

    def blank?
      false
    end

    def nil?
      false
    end

    def url
      raise NotImplementedError, ERROR_MESSAGE
    end

    def key
      raise NotImplementedError, ERROR_MESSAGE
    end
  end
end
