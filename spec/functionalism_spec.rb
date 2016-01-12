require 'spec_helper'
require 'functionalism'

describe ".compose" do
  context 'with pure functions of a single integer variable' do
    let(:f) { ->(x) {  x * 2 } }
    let(:g) { ->(x) { x ** 3 } }

    let(:value) { 10 }

    it 'should be able to compose a function with itself' do
      expect(f.compose(f).call(value)).to eq(value * 2 * 2)
      expect(f.compose(f).compose(f).call(value)).to eq(value * 2 * 2 * 2)
    end

    it 'should produce functions composed of two different functions' do
      expect(f.compose(g).call(value)).to eq((value * 2) ** 3)
      expect(g.compose(f).call(value)).to eq((value ** 3) * 2)

      expect(g.compose(f).call(value)).to eq(f.call(g.call(value)))
    end

    it 'should have a binary operator (|)' do
      expect(
        (f | g).call(value)
      ).to eq(
        (value * 2) ** 3
      )
    end

    context 'chaining' do
      let(:h) { ->(x) {  x / 5 } }

      it 'should work' do
        expect( f.compose(g).compose(h).call(value) ).to eq(1600)
      end

      it 'should be associative' do
        expect(
          f.compose(g).compose(h).call(value)
        ).to eq(
          f.compose(g.compose(h)).call(value)
        )
      end

      it 'should be associative with binary operators' do
        expect(
          (( f | g ) | h).call value
        ).to eq(
          ( f | ( g | h )).call value
        )
      end

      it 'should compose a function with itself multiple times' do
        expect( (f.functional_power(3)).call(value) ).to eql( (f | f | f).call(value) )
      end

      it 'should provide an operator (^) to shorthand functional powers' do
        expect( (f ^ 0).call(value) ).to eql( value )
        expect( (f ^ 1).call(value) ).to eql( (f).call(value) )
        expect( (f ^ 2).call(value) ).to eql( (f | f).call(value) )
        expect( (f ^ 3).call(value) ).to eql( (f | f | f).call(value) )
      end
    end
  end

  context 'with impure functions' do
    let(:inp) { -> { gets }}
    let(:out) { ->(x) { print x }}
    let(:cap) { ->(s) { s.capitalize }}

    it 'should compose two functions' do
      expect(self).to receive(:gets).and_return('foo')
      expect { (inp | out).call }.to output("foo").to_stdout
    end

    it 'should compose three functions' do
      expect(self).to receive(:gets).and_return('bar')
      expect { (inp | cap | out).call }.to output("Bar").to_stdout
    end
  end
end

context '.sum' do
  let(:f) { ->(x) { x * 5 }}
  let(:g) { ->(x) { x + 1 }}

  let(:value) { 4 }

  it 'should compute the sum of two functions' do
    expect( f.sum(g).call(value) ).to eq(25)
    expect( f.sum(g).call(value) ).to eq( f.call(value) + g.call(value) )
  end

  it 'should provide an operator (+) to shorthand function summation' do
    expect( ( f + g ).call(value) ).to eq( 25 )
  end
end

context '.product' do
  let(:f) { ->(x) { x ** 2 }}
  let(:g) { ->(x) { x * 3 }}

  let(:value) { 30 }

  it 'should generate the product of two functions' do
    expect( f.product(g).call(value) ).to eq( 81000 )
    expect( f.product(g).call(value) ).to eq( f.call(value) * g.call(value)   )
  end

  it 'should provide an operator (*) to shorthand function products' do
    expect( ( f * g ).call(value) ).to eq( 81000 )
  end
end

context '.exponentiate' do
  let(:f) { ->(x) { x * 2 }}
  let(:value) { 3 }

  it 'should generate the n-fold product of itself' do
    expect( f.exponentiate(2).call(value) ).to eq( 36 )
    expect( f.exponentiate(2).call(value) ).to eq( (f * f).call(value) )
  end

  it 'should provide an operation (**) to shorthand n-fold product' do
    expect( (f ** 0).call(value) ).to eq(value)
    expect( (f ** 1).call(value) ).to eq( f.call(value) )
    expect( (f ** 2).call(value) ).to eq( (f * f).call(value) )
    expect( (f ** 3).call(value) ).to eq( (f * f * f).call(value) )
    expect( (f ** 4).call(value) ).to eq( (f * f * f * f).call(value) )
  end
end

context '.memoize' do
  let(:f) { -> { rand }}
  let(:f_memo) { f.memoize }

  let(:g) { ->(x) { x * 2 }}
  let(:g_memo) { g.memoize }

  it 'should always produce the same value for a nullary function' do
    expect(f_memo.call).to eq(f_memo.call)
    expect(f_memo.call).to eq(f_memo.call)
  end

  it 'should produce the originally-computed values for a function of a single var' do
    expect(g_memo.call(3)).to eq(6)
    expect(g_memo.call(3)).to eq(g_memo.call(3))

    expect(g_memo.call(4)).to eq(8)
    expect(g_memo.call(4)).to eq(g_memo.call(4))
  end
end
