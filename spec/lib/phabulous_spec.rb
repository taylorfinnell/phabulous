require 'spec_helper'

describe Phabulous do
  it 'has a version number' do
    expect(Phabulous::VERSION).not_to be nil
  end

  it 'is configurable' do
    Phabulous.configure do |config|
      config.host = 'config_host_test'
      config.user = 'config_user_test'
      config.cert = 'config_cert_test'
    end

    expect(Phabulous.configuration.host).to eq('config_host_test')
    expect(Phabulous.configuration.user).to eq('config_user_test')
    expect(Phabulous.configuration.cert).to eq('config_cert_test')
  end

  it 'has a conduit client instance' do
    expect(Phabulous.conduit).to be_a(Phabulous::Conduit::Client)
  end
end
