require 'spec_helper'

describe Constant do
  it 'should create constant functions' do
    expect(Constant["foo"].call).to eql('foo')
    expect(Constant[1_000_000].call).to eql(1_000_000)
  end

  describe 'important named constant functions' do
    it 'should have a representation for f=0' do
      expect(Zero.call).to eq(0)
    end

    it 'should have a representation of f=1' do
      expect(One.call).to eq(1)
    end

    it 'should have a representation of f=2' do
      expect(Two.call).to eq(2)
    end

    it 'should have a representation of f=10' do
      expect(Ten.call).to eq(10)
    end
  end
end
