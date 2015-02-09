
module Phabulous
  class Feed < Entity
    attr_accessor :authorPHID, :data, :storyType, :storyText

    alias :storyAuthorPHID= :authorPHID=
    alias :storyData= :data=
    alias :text= :storyText=

    alias :text :storyText
    alias :type :storyType

    def author
      User.find(self.authorPHID)
    end
  end
end
