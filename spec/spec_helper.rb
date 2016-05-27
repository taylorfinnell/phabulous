$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'bundler'
Bundler.require :default, :test, :development

def conduit_test_key
  @conduit_test_key ||= File.read(File.join(File.dirname(File.expand_path(__FILE__)), 'data', '.arcrc')).chomp!
end

def test_phabricator_host
  "http://127.0.0.1:8080"
end

def test_phabricator_user
  'phabricator'
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.ignore_localhost = true
end

Phabulous.configure do |config|
  config.host = test_phabricator_host
  config.user = test_phabricator_user
  config.cert = conduit_test_key
end
