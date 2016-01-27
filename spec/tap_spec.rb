require 'spec_helper'

describe Tap do
  before do
    @other_pipeline_received = []
  end

  let(:pipeline) do
    :split.(' ') | Tap[other_pipeline] | :capitalize.each | :join.(' ')
  end

  it 'should work as though the T was not there' do
    expect(pipeline["dear sir or madam"]).to eq("Dear Sir Or Madam")
  end

  let(:other_pipeline) do
    ->(x) { @other_pipeline_received << x }
  end

  it 'should pass to another pipeline like tee' do
    expect{ pipeline[ 'name: margaretha zelle' ] }.to change(@other_pipeline_received, :size).by(1)
  end

  it 'should pass the right data' do
    expect(@other_pipeline_received).to receive(:<<).with(%w[ hello there ])

    pipeline["hello there"] 
  end
end
