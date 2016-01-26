require 'spec_helper'

describe 'Zip' do
  let(:a) { [1,2,3] }
  let(:b) { [4,5,6] }

  it 'weaves two arrays together' do
    expect(Zip[a,b]).to eq([[1,4],[2,5],[3,6]])
  end
end

describe 'Unzip' do
  let(:a) { [1,4] }
  let(:b) { [2,5] }
  let(:c) { [3,6] }

  it 'weaves several arrays together' do
    expect(Unzip[[a,b,c]]).to eq([[1,2,3],[4,5,6]])
  end

  it 'is the inverse of zip' do
    property_of { array(2) { array(10) { integer } }}.check do |(a,b)|
      expect(Unzip[Zip[a,b]]).to eq([a,b])
    end
  end
end

