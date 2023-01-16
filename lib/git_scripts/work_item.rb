# frozen_string_literal: true

class WorkItem
  attr_reader :project, :number, :title

  def initialize(message)
    process_message(message)
  end

  def to_h
    {
      title:,
      key:,
      url:
    }
  end

  def blank?
    project.blank? || number.blank? || title.blank?
  end

  def ado?
    return false if blank?

    return true if project == 'ADO'
    return true if number.size >= 6

    false
  end

  def jira?
    return false if blank?
    return false if project == 'ADO'
    return true if number.size <= 5

    false
  end

  def url
    return "https://dev.azure.com/tr-commercial-eng/Commercial%20Engineering/_workitems/edit/#{number}" if ado?
    return "https://jira.thomsonreuters.com/browse/#{key}" if jira?

    ''
  end

  def key
    @key ||= "#{project}-#{number}"
  end

  def <=>(other)
    return -1 if project < other.project
    return 1 if project > other.project

    number.to_i <=> other.number.to_i
  end

  private

  def process_message(value)
    regex = /^([A-Za-z]+)-(\d+)-(.+)$/

    unless value.match? regex
      @project = ''
      @key = ''
      @title = ''

      return
    end

    @project = value.match(regex)[1].upcase
    @project = 'ADO' if @project.empty?
    @number = value.match(regex)[2]
    @title = value.match(regex)[3].titlecase

    return unless @project == 'VERSION'

    @project = ''
    @number = ''
    @title = ''
  end
end
