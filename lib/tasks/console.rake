desc 'Open a pry console for debugging'
task :console do
  ENV['ENV'] ||= 'development'

  require 'rubygems'
  require 'bundler/setup'
  require 'dotenv/load'

  Bundler.require :default, :test, :development

  Phabulous.configure do |config|
    config.host = ENV.fetch('PHABRICATOR_HOST')
    config.user = ENV.fetch('PHABRICATOR_USER')
    config.cert = ENV.fetch('PHABRICATOR_KEY')
  end
  Phabulous.connect!

  binding.pry
end
