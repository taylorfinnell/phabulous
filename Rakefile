require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Dir.glob('lib/tasks/**/*.rake') do |file|
  load file
end

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

