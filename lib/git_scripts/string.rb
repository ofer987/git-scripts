# frozen_string_literal: true

require_relative 'work_item/base'
require_relative 'work_item/ado'
require_relative 'work_item/jira'
require_relative 'work_item/ritm'
require_relative 'work_item/nil'

class String
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

  def to_titlecase
    words = strip.titlecase.split(/\s+/)

    first_word = words[0]
    rest_words = words[1..]

    first_word = PROPER_NOUNS[first_word.downcase] || first_word
    rest_words = rest_words
      .map { |word| PROPER_NOUNS[word.downcase] || word }
      .map { |word| LOWER_CASE_WORDS[word.downcase] || word }
      .join(' ')

    [first_word, rest_words].join(' ')
  end

  def to_sentencecase
    words = strip.split(/\s+/)

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
end
