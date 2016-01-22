require 'spec_helper'

describe Functionalism do
  context "a pipeline" do
    describe 'a tiny string-oriented pipeline' do
      let(:pipeline) do
        :split.(' ') | :capitalize.each | :reverse | :join.(' ')
      end

      it 'should build simple pipelines' do
        expect( pipeline.("hello world") ).to eql("World Hello")
      end
    end

    describe 'for numeric composition with ranges' do
      let(:divisible_by_seven) { ->(x) { x % 7 == 0 } }

      let(:pipeline) do
        Filter[divisible_by_seven] | Sum
      end

      it 'should handle a small set' do
        expect( pipeline.(1..10_000) ).to eql( 7142142 )
      end

      it 'should handle a slightly larger set', speed: 'slow' do
        expect( pipeline.(1..20_000) ).to eql( 28578571 )
      end

      it 'should handle an even larger set', speed: 'slow' do
        expect( pipeline.(1..30_000) ).to eql( 64279285 )
      end

      it 'should handle a somewhat large set', speed: 'slow' do
        expect( pipeline.(1..40_000) ).to eql( 114294285 )
      end

      it 'should handle a very large set', speed: 'slow' do
        expect( pipeline.(1..100_000) ).to eql( 714264285 )
      end

      it 'should handle a huge set', speed: 'slow' do
        expect( pipeline.(1..250_000) ).to eql( 4464339285 )
      end
    end
  end
end
