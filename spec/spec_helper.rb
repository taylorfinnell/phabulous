$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'bundler'
Bundler.require :default, :test, :development

def conduit_test_key
  @conduit_test_key ||= File.read(File.join(File.dirname(File.expand_path(__FILE__)), 'data', '.arcrc')).chomp!
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.ignore_localhost = true
end

Phabulous.configure do |config|
  config.host = 'http://192.168.0.3:8081'
  config.user = 'user'
  config.cert = conduit_test_key
end
