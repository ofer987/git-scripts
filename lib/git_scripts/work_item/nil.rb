# frozen_string_literal: true

module WorkItem
  class Nil < Base
    def url
      ''
    end

    def key
      ''
    end

    def blank?
      true
    end

    def nil?
      true
    end
  end
end
