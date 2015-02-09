desc 'Open a pry console for debugging'
task :console do
  ENV['ENV'] ||= 'development'

  require 'rubygems'
  require 'bundler/setup'
  Bundler.require :default, :test, :development

  VCR.turn_off!
  WebMock.disable!

  conduit_test_key ||= File.read(File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec', 'data', '.arcrc')).chomp!

  Phabulous.configure do |config|
    config.host = 'http://192.168.0.3:8081'
    config.user = 'user'
    config.cert = conduit_test_key
  end
  Phabulous.connect!

  binding.pry
end
