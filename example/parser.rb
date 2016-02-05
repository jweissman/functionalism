require 'functionalism'
include Functionalism

class Token
  def initialize(value=nil)
    @value = value
  end

  def inspect; @value end

  def self.single_char?
    true
  end
end

class NumericLiteral < Token
  attr_reader :value

  def self.single_char?
    false
  end

  def self.matches?(ch)
    ch.match(/[0-9]/)
  end
end

class ArithmeticOperator < Token; end

class AdditionOperator < ArithmeticOperator
  def self.matches?(ch)
    ch == '+'
  end

  def apply(a,b)
    a+b
  end
end

class SubtractionOperator < ArithmeticOperator
  def self.matches?(ch)
    ch == '-'
  end

  def apply(a,b)
    a-b
  end
end

class MultiplicationOperator < ArithmeticOperator
  def self.matches?(ch)
    ch == '*'
  end

  def apply(a,b)
    a*b
  end
end

class DivisionOperator < ArithmeticOperator
  def self.matches?(ch)
    ch == '/'
  end

  def apply(a,b)
    a/b
  end
end

class ExponentiationOperator < ArithmeticOperator
  def self.matches?(ch)
    ch == '^'
  end

  def apply(a,b)
    a ** b
  end
end

class LeftParenthesis < Token
  def self.matches?(ch)
    ch == '('
  end
end

class RightParenthesis < Token
  def self.matches?(ch)
    ch == ')'
  end
end

class ArithmeticGrammar
  def start
    :expr
  end

  def token_list
    Filter[IsClass].(rules.values)
  end

  def rules
    {
      :expr   => [ %i[ expr plus term ], %i[ expr minus term ], :term ],
      :term   => [ %i[ term times power ], %i[ term div power ], :power ],
      :power  => [ %i[ power to_the factor ], :factor ],

      :factor => [ :digits, %i[ left_parens expr right_parens ]],

      :plus         => AdditionOperator,
      :minus        => SubtractionOperator,
      :times        => MultiplicationOperator,
      :div          => DivisionOperator,
      :to_the       => ExponentiationOperator,
      :digits       => NumericLiteral,
      :left_parens  => LeftParenthesis,
      :right_parens => RightParenthesis
    }
  end

  def parse(string)
    Compose[[
      Tokenize[token_list],
      Flip[Recognize[self]][start],
      Synthesize,
      :to_s
    ]].(string)
  end
end

# parse impl

RecognizeSingleForm = lambda do |grammar, production, tokens|
  Recognize[grammar, tokens, production]
end.curry

RecognizeSubexpression = lambda do |grammar, (left,middle,right), tokens|
  found_left,found_right =
    First[tokens].is_a?(grammar.rules[left]),
    Last[tokens].is_a?(grammar.rules[right])

  Recognize[grammar, Inner[tokens], middle] if found_left && found_right
end.curry

RecognizeBinaryOperation = lambda do |grammar, (left,middle,right), tokens|
  matching_operator = IsA[grammar.rules[middle]]
  i = RightIndex[tokens, matching_operator]

  if i && i > 0
    found_op = tokens[i]
    left_operand  = Recognize[grammar, Take[i,tokens], left]
    right_operand = Recognize[grammar, Drop[i+1,tokens], right]
    if left_operand && right_operand
      { found_op => { left: left_operand, right: right_operand }}
    end
  end
end.curry

IsTokenType = DescendsFrom[Token]
IsOperatorType = DescendsFrom[ArithmeticOperator]

RecognizeProduction = lambda do |grammar, tokens, production|
  left,middle,right = *production
  if IsOperatorType[grammar.rules[middle]]
    RecognizeBinaryOperation[grammar,production,tokens]
  elsif IsTokenType[grammar.rules[left]] && IsTokenType[grammar.rules[right]]
    RecognizeSubexpression[grammar,production,tokens]
  elsif IsSymbol[production]
    RecognizeSingleForm[grammar,production,tokens]
  end
end.curry

RecognizeProductions = lambda do |grammar,tokens,productions|
  Detect[IsTruthy][
    Map[RecognizeProduction[grammar,tokens]][productions]
  ]
end

RecognizeTokenLiteral = lambda do |grammar,tokens,rule|
  First[tokens] if First[tokens].is_a?(grammar.rules[rule]) && Length[tokens] == 1
end

Recognize = lambda do |grammar, tokens, rule|
  if IsTokenType[grammar.rules[rule]]
    RecognizeTokenLiteral[grammar,tokens,rule]
  else
    RecognizeProductions[grammar,tokens,grammar.rules[rule]]
  end
end.curry

# tokenize

TokenMatches = ->(token, ch) { token.matches?(ch) }.curry

MatchOneToken = lambda do |token, string|
  chars = string.chars
  matches = TokenMatches[token]
  if matches[chars.first]
    if token.single_char?
      x,*xs = *chars
      [ token.new(x), Join[xs] ]
    else
      [ token.new( Join[TakeWhile[matches,chars]] ), Join[DropWhile[matches,chars]] ]
    end
  end
end.curry

Matches = ->(token_list) { Orbit[Map[MatchOneToken][token_list]] }

ConsumeOnce = lambda do |token_list, string|
  Detect[IsTruthy][Matches[token_list][string]] unless string.nil?
end.curry

Tokenize = ->(token_list) { UnfoldStrict[ConsumeOnce[token_list]] }

# eval

Synthesize = lambda do |ast|
  if ast.is_a?(NumericLiteral)
    ast.value.to_i
  else
    op = ast.keys.first
    root = ast[op]
    l,r = root[:left], root[:right]
    op.apply(Synthesize[l], Synthesize[r])
  end
end

Rep = lambda do |evaluate|
  Compose[[ Wrap[Print, " > "], Gets, Chomp, evaluate, Puts ]]
end

Repl = ->(evaluate) { Forever[Rep[evaluate]] }
EvaluateArithmetic = ArithmeticGrammar.new.method(:parse)

Repl[EvaluateArithmetic] if __FILE__==$0
