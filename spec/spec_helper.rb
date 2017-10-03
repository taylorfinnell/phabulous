$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'bundler'
require 'webmock/rspec'

Bundler.require :default, :test, :development

Phabulous.configure do |config|
  config.host = 'http://127.0.0.1:8080/'
  config.user = 'testuser'
  config.cert = 'xxx'
end
