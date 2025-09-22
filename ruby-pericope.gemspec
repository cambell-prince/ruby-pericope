# frozen_string_literal: true

require_relative "lib/ruby/pericope/version"

Gem::Specification.new do |spec|
  spec.name = "ruby-pericope"
  spec.version = Ruby::Pericope::VERSION
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.authors = ["Cambell Prince"]
  spec.email = ["cambell.prince@gmail.com"]

  spec.summary = "A Ruby gem for handling pericopes"
  spec.description = "A library for parsing and manipulating biblical pericopes and references"
  spec.homepage = "https://github.com/cambell-prince/ruby-pericope"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.1"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cambell-prince/ruby-pericope"
  spec.metadata["changelog_uri"] = "https://github.com/cambell-prince/ruby-pericope/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
