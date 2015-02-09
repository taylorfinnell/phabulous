require 'spec_helper'

module Phabulous
  describe Revision do

    describe 'uri' do
      before do
        @diff = Revision.new(uri: 'http://google.com')
      end

      it 'returns a uri object' do
        expect(@diff.uri).to be_a(URI)
      end
    end

    describe 'dateModified' do
      before do
        @time = Time.now.to_i
        @diff = Revision.new(dateModified: @time.to_s)
      end

      it 'returns a time object' do
        expect(@diff.dateModified).to be_a(Time)
      end

    end

    describe 'author' do
      it 'returns a user object' do
        id = 'id'
        diff = Revision.new(authorPHID: id)

        user = double
        expect(User).to receive(:find).with(id).and_return(user)

        expect(diff.author).to equal(user)
      end
    end

    describe 'differential_id' do
      it 'returns the full differential id' do
        @diff = Revision.new(id: 1)

        expect(@diff.differential_id).to eq('D1')
      end
    end

    describe 'reviewers' do
      before do
        @reviewer_id = 1

        @diff = Revision.new(reviewers: [
          @reviewer_id
        ])
      end

      it 'returns an array of user objects' do
        user = double
        expect(User).to receive(:find).with(@reviewer_id).and_return(user)

        expect(@diff.reviewers.first).to equal(user)
      end
    end

  end
end

