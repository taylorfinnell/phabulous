require 'uri'

module Phabulous
  class User < Entity
    attr_accessor :title, :uri, :dateModified,
      :authorPHID, :image, :roles, :userName, :realName

    def id
      @phid
    end

    def name
      @userName
    end
  end
end
