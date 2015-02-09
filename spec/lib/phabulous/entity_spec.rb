require 'spec_helper'

module Phabulous
  describe Entity do

    before do
      class FakeEntity < Entity
        attr_accessor :hi, :x
      end
    end

    it 'sets attributes on instantiation' do
      fake_model = FakeEntity.new(hi: 'hi')

      expect(fake_model.hi).to eq('hi')
    end

    it 'tracks class attribute names' do
      expect(FakeEntity.attributes).to eq([:hi, :x])
    end

    it 'has an attribues hash of attribute names and their values' do
      fake_model = FakeEntity.new(hi: 'test')

      expect(fake_model.attributes).to eq({hi: 'test', x: nil})
    end

    describe 'conduit_name' do
      it 'defaults to the class name' do
        expect(Entity.conduit_name).to eq('entity')
      end
    end

    describe 'find' do
      it 'finds an entity by id' do
        model = FakeEntity.new(phid: 1)
        expect(FakeEntity).to receive(:all).and_return([model])

        expect(FakeEntity.find(1)).to eq(model)
      end
    end

    describe 'all' do
      before do
        FakeEntity.instance_variable_set(:@all, nil)
      end

      it 'queries conduit and returns all found entities' do
        attributes = [
          {
            x: 1,
            hi: 1
          },
          {
            x: 2,
            hi: 2
          }
        ]

        expect(Phabulous.conduit).to receive(:request).and_return(attributes)

        expect(FakeEntity.all.collect(&:attributes)).to eq([{
          x: 1,
          hi: 1
        },{
          x: 2,
          hi: 2
        }])
      end

      it 'supports both response types from conduit' do
        attributes = {
          "PHID-1" => {
            x: 1,
            hi: 1
          },
          "PHID-2" => {
            x: 2,
            hi: 2
          }
        }

        expect(Phabulous.conduit).to receive(:request).and_return(attributes)

        expect(FakeEntity.all.collect(&:attributes)).to eq([{
          x: 1,
          hi: 1
        },{
          x: 2,
          hi: 2
        }])
      end
    end
  end
end

