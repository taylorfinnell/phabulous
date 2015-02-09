require 'uri'

module Phabulous
  class Revision < Entity
    attr_accessor :id, :title, :uri, :dateModified, :authorPHID,
      :reviewers, :statusName, :lineCount, :summary, :statusName

    def status
      @statusName
    end

    def uri
      URI.parse(@uri)
    end

    def dateModified
      Time.at(@dateModified.to_i)
    end

    def author
      User.find(@authorPHID)
    end

    def differential_id
      "D#{id}"
    end

    def reviewers
      @reviewers.collect { |reviewier| User.find(reviewier) }
    end

    protected

    def self.conduit_name
      'differential'
    end
  end
end
