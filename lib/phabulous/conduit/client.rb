require 'digest'
require 'httparty'

module Phabulous
  module Conduit
    class Client
      include ::HTTParty

      Error = Class.new(RuntimeError)

      attr_accessor :host, :user, :cert, :token, :session

      def initialize(host = Phabulous.configuration.host,
                     user = Phabulous.configuration.user,
                     cert = Phabulous.configuration.cert)
        self.host = host
        self.user = user
        self.cert = cert
        self.session = nil
      end

      def ping
        request('conduit.ping')
      end

      def connect
        self.token = Time.now.to_i

        if result = request('conduit.connect', connection_payload)
          self.session = Conduit::Session.new(result['connectionID'], result['sessionKey'])
        end

        session
      end

      def request(method, data = {})
        response = self.class.post(
          File.join(host, 'api', method),
          body: post_body(data), headers: { 'Content-Type' => 'application/json' }
        )

        if response.parsed_response['result']
          response.parsed_response['result']
        else
          raise Error, "Conduit error: #{response.parsed_response['error_info']}"
        end
      end

      protected

      def post_body(data)
        data[:__conduit__] = session.to_hash if session

        { params: data.to_json, output: 'json' }
      end

      def connection_payload
        {
          'client' => "phabulous gem",
          'clientVersion' => Phabulous::VERSION,
          'user' => self.user,
          'host' => self.host,
          'authToken' => self.token,
          'authSignature' => auth_signature
        }
      end

      def auth_signature
        Digest::SHA1.hexdigest("#{token}#{cert}")
      end
    end
  end
end
