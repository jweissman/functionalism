require 'example_helper'

describe 'Tokenize' do
  it 'should tokenize a string' do
    property_of { array(2) { i=integer; guard i>0; i } }.check do |(i,j)|
      expr = "#{i}+#{j}"
      tokens = Tokenize.(expr)
      concatted_tokens = tokens.map(&:inspect).join
      expect(concatted_tokens).to eq(expr)
    end
  end
end

describe Parser do
  subject(:parser) { Parser.new }

  it 'should parse an expression' do
    expect(parser.evaluate("2+2")).to eq("4")
  end

  it 'should parse longer expressions' do
    expect(parser.evaluate("2+3+4")).to eq("9")
    expect(parser.evaluate("2-3+4")).to eq("3")
  end

  it 'should parse expressions with a single * or /' do
    expect(parser.evaluate("2*2+4")).to eq("8")
    expect(parser.evaluate("2+2*4")).to eq("10")
    expect(parser.evaluate("2*3+2*4")).to eq("14")
    expect(parser.evaluate("4/2")).to eq("2")
  end

  it 'should parse expressions with multiple * or /' do
    expect(parser.evaluate("4*5/2")).to eq("10")
  end

  it 'should parse parens on the left' do
    expect(parser.evaluate("(3+2)*4")).to eq("20")
    expect(parser.evaluate("(3+1)*5")).to eq("20")
  end

  it 'should parse parens on the right' do
    expect(parser.evaluate("3+(20-5)")).to eq("18")
    expect(parser.evaluate("3+(2*5)")).to eq("13")
  end

  it 'should parse parens in the middle/on left and right' do
    expect(parser.evaluate("5+(1*3)-4")).to eq("4")
    expect(parser.evaluate("(4+5)*(10-5+2)")).to eq("63")
  end

  it 'should parse nested parens' do
    expect(parser.evaluate("((3+1)+2)")).to eq("6")
  end

  it 'should parse complex expressions with nested parens' do
    expect(parser.evaluate("(1+2)*(4/(3-1))")).to eq("6")
  end
end
