require 'digest'
require 'httparty'

module Phabulous
  module Conduit
    class Client
      include ::HTTParty

      Error = Class.new(RuntimeError)

      attr_accessor :host, :user, :cert, :token, :session

      def initialize(_host = Phabulous.configuration.host,
                     _user = Phabulous.configuration.user, _cert = Phabulous.configuration.cert)
        self.host = _host
        self.user = _user
        self.cert = _cert
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

        self.session
      end

      def request(method, data = {})
        post_body = post_body(data)
        response = self.class.post("#{self.host}/api/#{method}", body: post_body,
                                   :headers => { 'Content-Type' => 'application/json' } )

        if response.parsed_response['result']
          response.parsed_response['result']
        else
          raise Error, "Conduit error: #{response.parsed_response['error_info']}"
        end
      end

      protected

      def post_body(data)
        if session
          data.merge!(__conduit__: self.session.to_hash)
        end

        { params: data.to_json, output: 'json' }
      end

      def connection_payload
        {
          'client' => "phabulous gem",
          'clientVersion' => Phabulous::VERSION,
          'user' => self.user,
          'host' => self.host,
          'authToken' => self.token,
          'authSignature' => auth_signature,
        }
      end

      def auth_signature
        Digest::SHA1.hexdigest("#{self.token}#{self.cert}")
      end
    end
  end
end
