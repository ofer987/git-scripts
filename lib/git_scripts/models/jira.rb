# frozen_string_literal: true

module GitScripts
  module Models
    class Jira
      REGEX = /([A-Za-z]+)-(\d+)/

      attr_reader :title

      class << self
        def init_from_github_title(title)
          return nil unless title.match? REGEX

          matches = title.match(REGEX)[1..2]
          Jira.new("#{matches[0].upcase}-#{matches[1]}")
        end
      end

      def initialize(title)
        @title = title.to_s
      end

      def <=>(other)
        first_part, second_part = Array(title.match(REGEX))[1..2]
        other_first_part, other_second_part = Array(other.title.match(REGEX))[1..2]

        precedence = first_part <=> other_first_part

        return precedence unless precedence.zero?

        second_part.to_i <=> other_second_part.to_i
      end

      def to_s
        title
      end

      private

      attr_writer :title
    end
  end
end
