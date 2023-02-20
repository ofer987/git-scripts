# frozen_string_literal: true

require_relative 'work_item/base'
require_relative 'work_item/ado'
require_relative 'work_item/jira'
require_relative 'work_item/ritm'
require_relative 'work_item/nil'

module WorkItem
  ERROR_MESSAGE = "#{self.class} is an abstract class".freeze
  INVALID = 'Could not determine whether it is an Azure DevOps, Jira, or RITM work item'

  class << self
    def create(value)
      regex = /^(?:ab-)?(\d+)(?:-(.*))?$/i
      if value.match? regex
        key, title = value.match(regex)[1..2]

        return ADO.new(key, title)
      end

      regex = /^RITM-(\d+)(?:-(.+))?$/i
      if value.match? regex
        key, title = value.match(regex)[1..2]

        return RITM.new(key, title)
      end

      regex = /^([A-Za-z]+)-(\d+)(?:-(.+))?$/i
      if value.match? regex
        project, key, title = value.match(regex)[1..3]

        return Jira.new(project, key, title)
      end

      Nil.new
    end
  end
end
