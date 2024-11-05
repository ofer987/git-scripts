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
        @to_s ||=
          "#{workflow} has failed in #{branch} with status #{status} (#{conclusion}) at #{started_at_in_utc} in UTC"
      end
    end
  end
end
