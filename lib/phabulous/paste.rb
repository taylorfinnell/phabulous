require 'uri'

module Phabulous
  class Paste < Entity
    attr_accessor :id, :content, :authorPHID, :uri

    def author
      User.find(@authorPHID)
    end

    def uri
      URI.parse(@uri)
    end
  end
end
