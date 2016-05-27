require 'spec_helper'

module Phabulous
  module Conduit
    describe Client do
      describe 'auth_signature' do
        before do
          @client = Conduit::Client.new
        end

        it 'is the sha1 digest of the conduit token and cert' do
          expect(@client).to receive(:token).and_return('token')
          expect(@client).to receive(:cert).and_return('cert')

          # sha1(tokencert)
          #  => 29ee2e11163771d305e17e3b3bbde765673f7fd8
          expect(@client.send(:auth_signature)).to eq('29ee2e11163771d305e17e3b3bbde765673f7fd8')
        end
      end

      describe 'connection_payload' do
        before do
          @client = Conduit::Client.new
        end

        it 'has a conduit name' do
          expect(@client.send(:connection_payload)['client']).to be
        end

        it 'has a conduit version' do
          expect(@client.send(:connection_payload)['clientVersion']).to be
        end

        it 'has a user' do
          expect(@client.send(:connection_payload)['user']).to be
        end

        it 'has a host' do
          expect(@client.send(:connection_payload)['host']).to be
        end

        it 'has a authToken' do
          expect(@client).to receive(:token).twice.and_return('token')

          expect(@client.send(:connection_payload)['authToken']).to be
        end

        it 'has a authSignature' do
          expect(@client.send(:connection_payload)['authSignature']).to be
        end
      end

      describe 'ping' do
        it 'raises an error on an unsucessful ping' do
          client = Conduit::Client.new(test_phabricator_host, 'fake', 'fake')

          expect {
            VCR.use_cassette('raises_conduit_errors_on_ping') do
              client.connect
              client.ping
            end
          }.to raise_exception(Client::Error)
        end

        it 'pings conduit' do
          client = Conduit::Client.new

          result = VCR.use_cassette('should_ping_conduit') do
            client.connect
            client.ping
          end

          expect(result).to be_a(String)
        end
      end

      describe '#connect' do
        before do
          @client = Conduit::Client.new
        end

        it 'should set the session' do
          VCR.use_cassette('should_set_the_session') do
            @client.connect
          end

          expect(@client.session).to be_a(Session)
        end

        it 'sets the token' do
          # not tested here, stub it
          expect(@client).to receive(:request)

          @client.connect

          expect(@client.token).to be
        end

        it 'connects with the connection payload' do
          fake_connection_payload = double

          expect(@client).to receive(:connection_payload).and_return(fake_connection_payload)

          expect(@client).to receive(:request).with('conduit.connect',
                                                     fake_connection_payload)

          @client.connect
        end
      end

      describe 'post_body' do
        it 'does not include session if session is nil' do
          client = Conduit::Client.new('url', test_phabricator_user, 'key')
          data_to_sign = {a: 1}

          session = nil
          expect(client).to receive(:session).and_return(session)

          signed_data = client.send(:post_body, data_to_sign)

          expect(signed_data).to eq({:params=>"{\"a\":1}", :output=>"json"})
        end

        it 'signs the request data with the session if the session exists' do
          client = Conduit::Client.new('url', test_phabricator_user, 'key')
          data_to_sign = {a: 1}

          session = double('session',
                           to_hash: {sessionKey: 'x', connectionID: 1})

          expect(client).to receive(:session).twice.and_return(session)

          signed_data = client.send(:post_body, data_to_sign)

          expect(signed_data).to eq({:params=>"{\"a\":1,\"__conduit__\":{\"sessionKey\":\"x\",\"connectionID\":1}}", :output=>"json"})
        end
      end

      describe '#request' do
        it 'raises errors when conduit erorrs' do
          client = Conduit::Client.new(test_phabricator_host, 'fake', 'fake_cert')

          expect {
            VCR.use_cassette('raises_conduit_errors') do
              client.request('conduit.connect')
            end
          }.to raise_exception(Client::Error)
        end

        it 'can make authorized requests' do
          client = Conduit::Client.new

          VCR.use_cassette('can_make_authorized_requests') do
            client.connect

            results = client.request('differential.query', ids: [1])
            expect(results).to eq([])
          end
        end
      end
    end
  end
end
