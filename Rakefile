# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Run tests"
task default: %i[spec rubocop]

desc "Run tests with coverage"
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].invoke
end

desc "Generate documentation"
task :doc do
  system "yard doc"
end

desc "Open console with gem loaded"
task :console do
  require "bundler/setup"
  require "ruby/pericope"
  require "pry"
  Pry.start
end
