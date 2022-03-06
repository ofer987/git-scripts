# frozen_string_literal: true

require 'active_support'
require 'octokit'
require 'rake'
require 'rest-client'
require 'uri'
require 'yaml'

require_relative 'git_scripts/version'

module GitScripts
  require_relative 'git_scripts/git'
  require_relative 'git_scripts/github'

  class Error < StandardError; end
  # Your code goes here...
end
