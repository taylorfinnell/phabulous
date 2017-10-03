require 'uri'

module Phabulous
  class Revision < Entity
    PREFIX = 'D'

    NEEDS_REVIEW    = 'Needs Review'
    CLOSED          = 'Closed'
    ACCEPTED        = 'Accepted'
    ABANDONED       = 'Abandoned'
    CHANGES_PLANNED = 'Changes Planned'
    NEEDS_REVISION  = 'Needs Revision'

    attr_accessor :id, :title, :uri, :dateModified, :authorPHID,
                  :reviewers, :statusName, :lineCount, :summary, :statusName

    class << self
      # @param [String, Integer] id.
      # @return [Phabulous::Revision]
      def find_by_differential_id(id)
        id.sub!(PREFIX, '')

        all.select { |entity| entity.id == id }.first
      end

      # @param [Array<String>] statuses.
      # @return [Array<Phabulous::Revision>]
      def by_status(*statuses)
        all.select { |entity| statuses.include?(entity.status) }
      end

      protected

      def conduit_name
        'differential'
      end
    end

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
  end
end
