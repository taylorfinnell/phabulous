require 'spec_helper'

describe String do
  describe 'demodulize' do
    it 'removes the module names from a string' do
      expect('Test::Test'.demodulize).to eq('Test')
    end
  end

  describe 'constantize' do
    it 'creates a constant from a string' do
      expect('Object'.constantize).to be_a(Object)
    end
  end
end
