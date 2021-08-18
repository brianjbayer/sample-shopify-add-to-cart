# frozen_string_literal: true

require 'bundler/audit/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Add Gem Tasks
Bundler::Audit::Task.new
RuboCop::RakeTask.new

# Custom Tasks
desc 'Run rubocop and bundler-audit'
task :checks do
  Rake::Task['rubocop'].invoke
  Rake::Task['bundle:audit'].invoke
end

# DEFAULT: Run specs in parallel
# TODO is this still necessary
desc 'run specs in parallel unless safari'
task :spec do
  if ENV['BROWSER'] == 'safari'
    warn 'rake: running specs SEQUENTIALLY for safari'
    RSpec::Core::RakeTask.new(:spec)

  else
    warn 'rake: running specs in PARALLEL'
    ruby '-S parallel_rspec spec'
  end
end

task default: :spec
