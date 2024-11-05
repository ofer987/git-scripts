# frozen_string_literal: true

module GitScripts
  class Workflow
    class Failure
      attr_reader :workflow, :branch, :status, :conclusion, :started_at_in_utc

      def initialize(workflow, branch, status, conclusion, started_at_in_utc)
        @workflow = workflow
        @branch = branch
        @status = status
        @conclusion = conclusion
        @started_at_in_utc = started_at_in_utc
      end

      def to_s
        return @to_s if defined? @to_s

        value = <<~HEREDOC
          #{workflow} (started at #{started_at_in_utc} in UTC) has failed in the #{branch} branch with status #{status} (#{conclusion})
        HEREDOC

        @to_s = value.chomp
      end
    end
  end
end
