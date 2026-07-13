# frozen_string_literal: true

require_relative 'work_item/base'
require_relative 'work_item/ado'
require_relative 'work_item/jira'
require_relative 'work_item/ritm'
require_relative 'work_item/nil'

module WorkItem
  ERROR_MESSAGE = "#{self.class} is an abstract class".freeze
  INVALID = 'Could not determine whether it is an Azure DevOps, Jira, or RITM work item'

  PROPER_NOUNS = {
    'github' => 'GitHub',
    'ado' => 'ADO',
    'azure devops' => 'Azure DevOps',
    'aem' => 'AEM',
    'ams' => 'AMS',
    'aemaacs' => 'AEMaaCS',
    'dam' => 'DAM',
    'os' => 'OS',
    'cli' => 'CLI'
  }.freeze

  LOWER_CASE_WORDS = {
    'is' => 'is',
    'being' => 'being',
    'to' => 'to'
  }.freeze

  class << self
    def to_titlecase(value)
      words = value.to_s.strip.titlecase.split(/\s+/)

      first_word = words[0]
      rest_words = words[1..]

      first_word = PROPER_NOUNS[first_word.downcase] || first_word
      rest_words = rest_words
        .map { |word| PROPER_NOUNS[word.downcase] || word }
        .map { |word| LOWER_CASE_WORDS[word.downcase] || word }
        .join(' ')

      [first_word, rest_words].join(' ')
    end

    def to_sentencecase(value)
      words = value.to_s.strip.split(/\s+/)

      first_word = words[0].titlecase
      rest_words = words[1..]

      first_word = PROPER_NOUNS[first_word.downcase] || first_word
      rest_words = rest_words
        .map(&:downcase)
        .map { |word| PROPER_NOUNS[word] || word }
        .map { |word| LOWER_CASE_WORDS[word] || word }
        .join(' ')

      [first_word, rest_words].join(' ')
    end

    def create(value)
      regex = /^(?:ado-)?(\d+)(?:-(.*))?$/i
      if value.match? regex
        key, title = value.match(regex)[1..2]

        return ADO.new(key, title)
      end

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

      Nil.new(value)
    end
  end
end
