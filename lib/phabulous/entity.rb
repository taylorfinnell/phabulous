module Phabulous
  class Entity
    def self.attr_accessor(*args)
      @attributes ||= []
      @attributes |= args
      super(*args)
    end

    def self.attributes
      @attributes
    end

    def self.all
      @all ||= Phabulous.conduit.request("#{conduit_name}.query").collect do |attributes|
        # Some conduit.query calls come back as plain arrays like
        #  [
        #    {
        #      attr: 1
        #     },
        #     {
        #     }
        #  ]
        # as
        # {
        #   phid => {
        #    attr1: x,
        #    ...
        #   },
        #   phid-2 => {
        #     attr2: y
        #   }
        # }
        #
        # This code attempts to handle both cases
        if attributes.length == 2 &&
            attributes.first.is_a?(String) && attributes.first =~ /^PHID.*$/
          new(attributes.last)
        else
          new(attributes)
        end
      end
    end

    def self.find(id)
      all.select { |entity| entity.phid == id }.first
    end

    def initialize(attributes = {})
      attributes.each do |attr, value|
        send("#{attr}=", value) if respond_to?("#{attr}=")
      end unless attributes.nil?
    end

    def attributes
      self.class.attributes.inject({}) do |memo, attr|
        memo[attr] = send(attr) if respond_to?(attr)
        memo
      end if self.class.attributes
    end

    attr_accessor :phid

    def self.conduit_name
      name.demodulize.downcase
    end
  end
end
