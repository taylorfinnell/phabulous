require 'securerandom'
require 'spec_helper'

module Phabulous
  module Conduit
    describe Session do
      before do
        @connection_id = 1
        @session_key = SecureRandom.uuid
        @session = Session.new(@connection_id, @session_key)
      end

      it 'creates a session from a connection id and session key' do
        expect(@session.session_key).to eq(@session_key)
        expect(@session.connection_id).to eq(@connection_id)
      end

      it 'can be represented as a hash' do
        expect(@session.to_hash).to eq({
          'sessionKey' => @session_key,
          'connectionID' => @connection_id
        })
      end
    end
  end
end
