module Phabulous
  module Conduit
    class Session
      attr_accessor :connection_id, :session_key

      def initialize(_connection_id, _session_key)
        self.connection_id = _connection_id
        self.session_key = _session_key
      end

      def to_hash
        { 'sessionKey' => self.session_key, 'connectionID' => self.connection_id }
      end
    end
  end
end
