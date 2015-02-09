require 'spec_helper'

module Phabulous
  describe User do
    it 'uses the phid as the id' do
      user = User.new(phid: 123)

      expect(user.id).to eq(123)
    end
  end
end

