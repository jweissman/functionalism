require 'spec_helper'

describe Proc do
  describe ".compose" do
    context 'with pure functions of a single integer variable' do
      let(:f) { ->(x) {  x * 2 } }
      let(:g) { ->(x) { x ** 3 } }

      let(:value) { 10 }

      it 'should be able to compose a function with itself' do
        expect(f.compose(f).(value)).to eq(value * 2 * 2)
        expect(f.compose(f).compose(f).(value)).to eq(value * 2 * 2 * 2)
      end

      it 'should produce functions composed of two different functions' do
        expect(f.compose(g).(value)).to eq((value * 2) ** 3)
        expect(g.compose(f).(value)).to eq((value ** 3) * 2)

        expect(g.compose(f).(value)).to eq(f.(g.(value)))
      end

      it 'should have a binary operator (|)' do
        expect(
          (f | g).(value)
        ).to eq(
        (value * 2) ** 3
        )
      end

      context 'chaining' do
        let(:h) { ->(x) {  x / 5 } }

        it 'should work' do
          expect( f.compose(g).compose(h).(value) ).to eq(1600)
        end

        it 'should be associative' do
          expect(
            f.compose(g).compose(h).(value)
          ).to eq(
          f.compose(g.compose(h)).(value)
          )
        end

        it 'should be associative with binary operators' do
          expect(
            (( f | g ) | h)[value]
          ).to eq(
          ( f | ( g | h ))[value]
          )
        end

        it 'should compose a function with itself multiple times' do
          expect( (f.functional_power(3)).(value) ).to eql( (f | f | f).(value) )
        end

        it 'should provide an operator (^) to shorthand functional powers' do
          expect( (f ^ 0).(value) ).to eql( value )
          expect( (f ^ 1).(value) ).to eql( (f).(value) )
          expect( (f ^ 2).(value) ).to eql( (f | f).(value) )
          expect( (f ^ 3).(value) ).to eql( (f | f | f).(value) )
        end
      end
    end

    context 'with impure functions' do
      let(:inp) { -> { gets }}
      let(:out) { ->(x) { print x }}
      let(:cap) { ->(s) { s.capitalize }}

      it 'should compose two functions' do
        expect(self).to receive(:gets).and_return('foo')
        expect { (inp | out)[] }.to output("foo").to_stdout
      end

      it 'should compose three functions' do
        expect(self).to receive(:gets).and_return('bar')
        expect { (inp | cap | out)[] }.to output("Bar").to_stdout
      end

      it 'should compose procs and symbols (converting implicitly to procs)' do
        expect(self).to receive(:gets).and_return('quux')
        expect { (inp | :upcase | out)[] }.to output("QUUX").to_stdout
      end
    end
  end

  context '.sum' do
    let(:f) { ->(x) { x * 5 }}
    let(:g) { ->(x) { x + 1 }}

    let(:value) { 4 }

    it 'should compute the sum of two functions' do
      expect( f.sum(g).(value) ).to eq(25)
      expect( f.sum(g).(value) ).to eq( f.(value) + g.(value) )
    end

    it 'should provide an operator (+) to shorthand function summation' do
      expect( ( f + g ).(value) ).to eq( 25 )
    end
  end

  context '.product' do
    let(:f) { ->(x) { x ** 2 }}
    let(:g) { ->(x) { x * 3 }}

    let(:value) { 30 }

    it 'should generate the product of two functions' do
      expect( f.product(g).(value) ).to eq( 81000 )
      expect( f.product(g).(value) ).to eq( f.(value) * g.(value)   )
    end

    it 'should provide an operator (*) to shorthand function products' do
      expect( ( f * g ).(value) ).to eq( 81000 )
    end
  end

  context '.exponentiate' do
    let(:f) { ->(x) { x * 2 }}
    let(:value) { 3 }

    it 'should generate the n-fold product of itself' do
      expect( f.exponentiate(2).(value) ).to eq( 36 )
      expect( f.exponentiate(2).(value) ).to eq( (f * f).(value) )
    end

    it 'should provide an operation (**) to shorthand n-fold product' do
      expect( (f ** 0).(value) ).to eq(value)
      expect( (f ** 1).(value) ).to eq( f.(value) )
      expect( (f ** 2).(value) ).to eq( (f * f).(value) )
      expect( (f ** 3).(value) ).to eq( (f * f * f).(value) )
      expect( (f ** 4).(value) ).to eq( (f * f * f * f).(value) )
    end
  end

  context '.memoize' do
    before do
      @f_called = 0
      @g_called = 0
      @h_called = 0
    end

    let(:f) { -> { @f_called += 1; rand }}
    let(:f_memo) { f.memoize }

    let(:g) { ->(x) { @g_called += 1; x * 2 }}
    let(:g_memo) { ~g } # shorthand for memoize

    let(:h) do
      ->(seed) { @h_called += 1; prng = Random.new(seed); prng.rand(100) }
    end
    let(:h_memo) { ~h }

    context 'a nullary function' do
      it 'should always produce the same value' do
        expect(f_memo[]).to eq(f_memo[])
        expect(@f_called).to eq(1)
      end
    end

    context 'functions of a single variable' do
      it 'should produce precomputed values for a pure fn' do
        expect(g_memo.(3)).to eq(6)
        expect(g_memo.(3)).to eq(g_memo.(3))

        expect(g_memo.(4)).to eq(8)
        expect(g_memo.(4)).to eq(g_memo.(4))

        expect(@g_called).to eq(2)
      end

      it 'should produce precomputed values for an impure fn' do
        expect(h_memo.(1234)).to eq(h_memo.(1234))
        expect(@h_called).to eq(1)
      end
    end

    context 'composed functions' do
      let(:cached_pipeline) { ~(f|g|h) }

      it 'should produce precomputed values' do
        expect(cached_pipeline[]).to eq(cached_pipeline[])

        expect(@f_called).to eq(1)
        expect(@g_called).to eq(1)
        expect(@h_called).to eq(1)
      end
    end
  end

  context '.map' do
    let(:f) { ->(x) { x * 2 }}
    let(:g) { ->(x) { x ** 3 }}

    it 'should map the proc over the array' do
      expect( f.map([1,2]) ).to eq([2,4])
    end

    it 'should provide a shorthand (%) for map' do
      expect( ~(f|g) % [3,6,9] ).to eq( [ 216, 1728, 5832 ] )
    end
  end

  context '.negate' do
    let(:greater_than_four) { ->(x) { x > 4 }}
    let(:not_greater_than_four) { greater_than_four.negate }

    it 'should invert the truth-value of the proc' do
      expect(greater_than_four.(5)).to be_truthy
      expect(greater_than_four.(3)).to be_falsy

      expect(not_greater_than_four.(5)).to be_falsy
      expect(not_greater_than_four.(3)).to be_truthy
    end

    it 'should provide a shorthand (unary -) for negate' do
      expect((-greater_than_four).(5)).to be_falsy
      expect((-greater_than_four).(3)).to be_truthy
    end
  end

  context '.filter' do
    let(:greater_than_four) { ->(x) { x > 4 }}

    it 'should use itself as a selector over the array' do
      expect(greater_than_four.filter([2,3,5,9])).to eq([5,9])
    end

    it 'should provide a shorthand (binary &) for filter' do
      expect(greater_than_four & [2,3,9,12]).to eq([9,12])
    end
  end

  context '.fold' do
    let(:f)  { :+.to_proc }

    it 'should inject' do
      expect( f.fold([2,3]) ).to eq(5)
      expect( :+.to_proc.foldr(%w[ hey yo ]) ).to eq("heyyo")
    end

    it 'should have a shorthand (<<)' do
      expect( f << [2,3,4] ).to eq(9)
      expect( f << [2,3,4] ).to eq(9)
      expect( :+.to_proc << %w[ hi there ] ).to eq("hithere")
      expect( :merge.to_proc << [{first: 'Tom'},{last: 'Jones'}] ).
        to eq({first: "Tom", last: "Jones"})
    end
  end

  context '.foldl' do
    it 'should inject right-to-left' do
      expect( :+.to_proc.foldl(%w[ hey yo ]) ).to eq("yohey")
    end

    it 'should have a shorthand (>>)' do
      expect( :+.to_proc >> %w[ hi there ] ).to eq("therehi")
      expect( :merge.to_proc >> [{first: 'Tom'},{last: 'Jones'}] ).
        to eq({first: "Tom", last: "Jones"})
    end
  end

  context '.iterate' do
    let(:f) do
      ->(x) { 1 + (x ** 2) }
    end

    it 'should produce Enumerators' do
      expect( f.iterate(1) ).to be_an(Enumerator)
    end

    it 'should generate the infinite set of results' do
      expect( f.iterate(1).take(5) ).to eq([1,2,5,26,677])
    end
  end

  context '.to_s' do
    it 'should identify known axiomatic functions' do
      expect(Identity.to_s).to eq('Id')
      expect(Fold.to_s).to eq('Fold')
    end

    it 'should identify composed functions' do
      expect(Last.to_s).to eq("Compose2[First, Fold[Cons]]")
      expect(Initial.to_s).to eq("Compose[Fold[Cons], Rest, Fold[Cons]]")
      expect(FixedPoint.to_s).to eq("Compose[Iterate, Pairwise, Compose2[First, Filter[PairMatches]], First]")
    end

    it 'should identify partially-applied folds, maps, filters and zips' do
      expect(Fold[Successor,1].to_s).to eq("Fold[Succ]")
      expect(Map[Identity].to_s).to eq("Map[Id]")
      expect(Mapr[Identity].to_s).to eq("Mapr[Id]")
      expect(ZipWith[Predecessor].to_s).to eq("ZipWith[Pred]")
      expect(UnzipWith[Predecessor].to_s).to eq("UnzipWith[Pred]")
      expect(Filter[:even?].to_s). to eq("Filter[even?]")
    end

    it 'should identify curried and procified symbols' do
      expect(AsProc[:+].to_s).to eql('AsProc[+]')
      expect(:+.(1).to_s).to eql("+[1]")
    end
  end
end
