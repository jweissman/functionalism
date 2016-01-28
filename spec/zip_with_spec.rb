require 'spec_helper'

describe 'Zip' do
  let(:a) { [1,2,3] }
  let(:b) { [4,5,6] }

  it 'weaves two arrays together' do
    expect(Zip[a,b]).to eq([[1,4],[2,5],[3,6]])
  end

  it 'weaves infinite sequencs together' do
    expect(
      Take[10,
        Zip[Iterate[Successor,0],Iterate[Successor,1]]
      ]).to eq(
        [
          [0,1],
          [1,2],
          [2,3],
          [3,4],
          [4,5],
          [5,6],
          [6,7],
          [7,8],
          [8,9],
          [9,10]
        ]
      )
  end
end

describe 'Unzip' do
  let(:a) { [1,4] }
  let(:b) { [2,5] }
  let(:c) { [3,6] }

  it 'weaves several arrays together' do
    expect(Unzip[[a,b,c]]).to eq([[1,2,3],[4,5,6]])
  end

  it 'weaves several infinite sequences together' do
    expect(
      Take[4,
        Unzip[[
          Iterate[Successor,0],
          Iterate[Successor,1],
          Iterate[Successor,2]
        ]]
      ]
    ).to eq([
      [0,1,2],[1,2,3],[2,3,4],[3,4,5]
    ])
  end

  it 'is the inverse of zip', speed: 'slow' do
    property_of { array(2) { array(3) { integer } }}.check do |(a,b)|
      expect(Unzip[Zip[a,b]]).to eq([a,b])
    end
  end
end

