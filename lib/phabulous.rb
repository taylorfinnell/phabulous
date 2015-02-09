require 'phabulous/version'
require 'phabulous/conduit'
require 'phabulous/configuration'

require 'phabulous/entity'
require 'phabulous/revision'
require 'phabulous/user'
require 'phabulous/feed'
require 'phabulous/paste'

require 'ext/string'

module Phabulous
  def self.connect!
    conduit.connect
  end

  def self.revisions
    Revision
  end

  def self.users
    User
  end

  def self.conduit
    @conduit ||= Conduit::Client.new
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
