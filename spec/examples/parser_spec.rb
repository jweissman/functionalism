require 'example_helper'

describe 'Tokenize' do
  let(:grammar) { ArithmeticGrammar.new }
  it 'should tokenize a string' do
    property_of { array(2) { i=integer; guard i>0; i } }.check do |(i,j)|
      expr = "#{i}+#{j}"
      tokens = Tokenize[grammar.token_list].(expr)
      concatted_tokens = tokens.map(&:inspect).join
      expect(concatted_tokens).to eq(expr)
    end
  end
end

describe 'Recognize' do
  let(:grammar) { ArithmeticGrammar.new }
  it 'should recognize literals' do
    literal = Recognize[grammar].(Tokenize[grammar.token_list].("123"), grammar.start)
    expect(literal).to be_a(NumericLiteral)
    expect(literal.value).to eq('123')
  end

  it 'should recognize expressions' do
    ast = Recognize[grammar].(Tokenize[grammar.token_list].("(1+3)"), grammar.start)
    op = ast.keys.first

    expect(op).to be_a(AdditionOperator)
    expect(ast[op][:left]).to be_a(NumericLiteral)
    expect(ast[op][:left].value).to eq('1')

    expect(ast[op][:right]).to be_a(NumericLiteral)
    expect(ast[op][:right].value).to eq('3')
  end
end

describe 'Parse' do
  let(:grammar) { ArithmeticGrammar.new }
  subject(:parse) { grammar.method(:parse) }

  it 'should parse an expression' do
    expect(parse.("2+2")).to eq("4")
  end

  it 'should parse longer expressions' do
    expect(parse.("2+3+4")).to eq("9")
    expect(parse.("2-3+4")).to eq("3")
  end

  it 'should parse expressions with a single * or /' do
    expect(parse.("2*2+4")).to eq("8")
    expect(parse.("2+2*4")).to eq("10")
    expect(parse.("2*3+2*4")).to eq("14")
    expect(parse.("4/2")).to eq("2")
  end

  it 'should parse expressions with multiple * or /' do
    expect(parse.("4*5/2")).to eq("10")
  end

  it 'should parse parens on the left' do
    expect(parse.("(3+2)*4")).to eq("20")
    expect(parse.("(3+1)*5")).to eq("20")
  end

  it 'should parse parens on the right' do
    expect(parse.("3+(20-5)")).to eq("18")
    expect(parse.("3+(2*5)")).to eq("13")
  end

  it 'should parse parens in the middle/on left and right' do
    expect(parse.("5+(1*3)-4")).to eq("4")
    expect(parse.("(4+5)*(10-5+2)")).to eq("63")
  end

  it 'should parse nested parens' do
    expect(parse.("((3+1)+2)")).to eq("6")
  end

  it 'should parse complex expressions with nested parens' do
    expect(parse.("(1+2)*(4/(3-1))")).to eq("6")
  end

  it 'should recognize exponents' do
    expect(parse.("1+2*3^2")).to eq("19") # 1+(2*(3^2)) = 1+(2*9)
  end
end
