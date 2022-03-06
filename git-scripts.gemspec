# frozen_string_literal: true

require_relative 'lib/git_scripts'

Gem::Specification.new do |spec|
  spec.name = 'git-scripts'
  spec.version = GitScripts::VERSION
  spec.authors = ['Dan Jakob Ofer']
  spec.email = ['dan@ofer.to']

  spec.summary = 'Various helper git scripts'
  spec.description = 'Various helper git scripts'
  spec.homepage = 'https://github.com/ofer987/dotfiles'
  spec.required_ruby_version = '~> 3.1'

  spec.metadata['allowed_push_host'] = 'https://github.com/ofer987/dotfiles'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ofer987/dotfiles'
  spec.metadata['changelog_uri'] = 'https://github.com/ofer987/dotfiles'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(File.expand_path(__dir__)) do
  #   `git ls-files -z`.split("\x0").reject do |f|
  #     (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
  #   end
  # end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry-byebug', '~> 3.9'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
