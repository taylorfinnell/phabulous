require 'spec_helper'

module Phabulous
  module Conduit
    describe Client do
      let(:subject) { Conduit::Client.new }

      before(:each) do
        stub_request(:post, File.join(Phabulous.configuration.host, 'api/conduit.connect'))
          .to_return(status: 200, body: { result: double(:result) }.to_json, headers: { content_type: 'application/json' })
      end

      describe '#auth_signature' do
        it 'is the sha1 digest of the conduit token and cert' do
          expect(subject).to receive(:token).and_return('token')
          expect(subject).to receive(:cert).and_return('cert')

          # sha1(tokencert)
          #  => 29ee2e11163771d305e17e3b3bbde765673f7fd8
          expect(subject.send(:auth_signature)).to eq('29ee2e11163771d305e17e3b3bbde765673f7fd8')
        end
      end

      describe '#connection_payload' do
        it 'has a conduit name' do
          expect(subject.send(:connection_payload)['client']).to be
        end

        it 'has a conduit version' do
          expect(subject.send(:connection_payload)['clientVersion']).to be
        end

        it 'has a user' do
          expect(subject.send(:connection_payload)['user']).to be
        end

        it 'has a host' do
          expect(subject.send(:connection_payload)['host']).to be
        end

        it 'has a authToken' do
          expect(subject).to receive(:token).twice.and_return('token')

          expect(subject.send(:connection_payload)['authToken']).to be
        end

        it 'has a authSignature' do
          expect(subject.send(:connection_payload)['authSignature']).to be
        end
      end

      describe '#ping' do
        it 'raises an error on an unsucessful ping' do
          response = {
            result: nil,
            error_code: 'ERR-INVALID-USER',
            error_info: 'The username you are attempting to authenticate with is not valid.'
          }.to_json

          client = Conduit::Client.new(Phabulous.configuration.host, 'fake', 'fake')

          stub_request(:post, File.join(Phabulous.configuration.host, 'api/conduit.connect'))
            .to_return(status: 200, body: response, headers: { content_type: 'application/json' })

          expect {
            client.connect
            client.ping
          }.to raise_exception(Client::Error)
        end

        it 'pings conduit' do
          response = { result: Phabulous.configuration.host, error_code: nil, error_info: nil }.to_json

          stub_request(:post, File.join(Phabulous.configuration.host, 'api/conduit.ping'))
            .to_return(status: 200, body: response, headers: { content_type: 'application/json' })

          subject.connect

          expect(subject.ping).to be_a(String)
        end
      end

      describe '#connect' do
        it 'should set the session' do
          subject.connect

          expect(subject.session).to be_a(Session)
        end

        it 'sets the token' do
          # not tested here, stub it
          expect(subject).to receive(:request)

          subject.connect

          expect(subject.token).to be
        end

        it 'connects with the connection payload' do
          payload = double(:payload)

          expect(subject).to receive(:connection_payload).and_return(payload)
          expect(subject).to receive(:request).with('conduit.connect', payload)

          subject.connect
        end
      end

      describe '#post_body' do
        it 'does not include session if session is nil' do
          client = Conduit::Client.new('url', 'user', 'key')

          data_to_sign = {a: 1}

          expect(client).to receive(:session).and_return(nil)

          signed_data = client.send(:post_body, data_to_sign)

          expect(signed_data).to eq({:params=>"{\"a\":1}", :output=>"json"})
        end

        it 'signs the request data with the session if the session exists' do
          client = Conduit::Client.new('url', 'user', 'key')
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
          response = {
            result: nil,
            error_code: 'ERR-INVALID-USER',
            error_info: 'The username you are attempting to authenticate with is not valid.'
          }.to_json

          client = Conduit::Client.new(Phabulous.configuration.host, 'fake', 'fake_cert')

          stub_request(:post, File.join(Phabulous.configuration.host, 'api/conduit.connect'))
            .to_return(status: 200, body: response, headers: { content_type: 'application/json' })

          expect { client.request('conduit.connect') }.to raise_exception(Client::Error)
        end

        it 'can make authorized requests' do
          response = { result: [{ test: true }], error_code: nil, error_info: nil }.to_json

          stub_request(:post, File.join(Phabulous.configuration.host, 'api/differential.query'))
            .to_return(status: 200, body: response, headers: { content_type: 'application/json' })

          subject.connect

          expect(subject.request('differential.query', ids: [1])).to eq([{ 'test' => true }])
        end
      end
    end
  end
end
