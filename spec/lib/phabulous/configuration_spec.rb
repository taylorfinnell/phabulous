require 'spec_helper'

module Phabulous
  describe Configuration do
    before do
      @config = Configuration.new
    end

    it 'allows user configuration' do
      @config.user =  'user'
      expect(@config.user).to eq('user')
    end

    it 'allows host configuration' do
      @config.host =  'host'
      expect(@config.host).to eq('host')
    end

    it 'allows cert configuration' do
      @config.cert =  'cert'
      expect(@config.cert).to eq('cert')
    end
  end
end
