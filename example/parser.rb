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

class ArithmeticOperator < Token
end

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

TokenList = [ NumericLiteral, AdditionOperator, SubtractionOperator, MultiplicationOperator, DivisionOperator, LeftParenthesis, RightParenthesis ]

# This grammar implements the following arithmetic behaviors:
#
# expr   -> expr + term | expr - term | term
# term   -> term * factor | term / factor | factor
# factor -> digits | (expr)
#
class ArithmeticGrammar
  def start; :expr end

  def rules
    {
      :expr   => [ %i[ expr plus term ], %i[ expr minus term ], :term ],
      :term   => [ %i[ term times factor ], %i[ term div factor ], :factor ],
      :factor => [ :digits, %i[ left_parens expr right_parens ]],

      :plus         => AdditionOperator,
      :minus        => SubtractionOperator,
      :times        => MultiplicationOperator,
      :div          => DivisionOperator,
      :digits       => NumericLiteral,
      :left_parens  => LeftParenthesis,
      :right_parens => RightParenthesis
    }
  end
end

RecognizeSingleTermForm = lambda do |grammar, production, tokens|
  Recognize[grammar].(tokens, production) if production.is_a?(Symbol)
end.curry

RecognizeSubexpression = lambda do |grammar, production, tokens|
  if grammar.rules[production[0]].is_a?(Class) &&
     grammar.rules[production[2]].is_a?(Class)

    left_to_find = grammar.rules[production[0]]
    middle_to_find = production[1]
    right_to_find = grammar.rules[production[2]]

    left,right = tokens.first, tokens.last

    if left.is_a?(left_to_find) && right.is_a?(right_to_find)
      Recognize[grammar].(tokens[1..-2], middle_to_find)
    end
  end
end.curry

RecognizeBinaryOperation = lambda do |grammar, production, tokens|
  if grammar.rules[production[1]].is_a?(Class)
    left_to_find = production[0]
    op_to_find = grammar.rules[production[1]] # we want the class
    right_to_find = production[2]

    i = tokens.rindex { |o| o.is_a?(op_to_find) }
    if i && i > 0

      found_op = tokens[i]
      left,right = tokens.take(i), tokens.drop(i+1)

      left_operand = Recognize[grammar].(left, left_to_find)
      right_operand = Recognize[grammar].(right, right_to_find)

      if left_operand && right_operand
        { found_op => { left: left_operand, right: right_operand }}
      end
    end
  end
end.curry

RecognizeKnownProductionForms = lambda do |grammar, production, tokens|
  Orbit[[
    RecognizeSingleTermForm,
    RecognizeSubexpression,
    RecognizeBinaryOperation
  ]].([grammar, production, tokens])
end.curry

RecognizeRule = lambda do |grammar, rule, tokens|
  FirstTruthySubelement[
    Map[->(production) {
      RecognizeKnownProductionForms[grammar, production, tokens]
    }].( grammar.rules[rule] )
  ]
end

Truthy = ->(x) { !!x }
FirstTruthySubelement = Compose[[ Flatten, Filter[Truthy], First ]]

Recognize = lambda do |grammar|
  lambda do |tokens, key|
    if grammar.rules[key].is_a?(Class)
      fst = tokens.first
      if fst.is_a?(grammar.rules[key]) && tokens.size == 1
        fst
      end
    else
      RecognizeRule[grammar,key,tokens]
    end
  end
end

TokenMatches = ->(token, ch) { token.matches?(ch) }.curry

MatchOneToken = lambda do |token|
  matches = TokenMatches[token]
  Proc.new("MatchOne[#{token}]") do |string|
    chars = string.chars
    if matches[chars.first]
      if token.single_char?
        x,*xs = *chars
        [ token.new(x), xs.join ]
      else
        [ token.new(chars.take_while(&matches).join),
          chars.drop_while(&matches).join ]
      end
    end
  end
end

Matches = Orbit[Map[MatchOneToken][TokenList]]

ConsumeOnce = lambda do |string|
  return if string.empty?
  Detect[Truthy][Matches[string]]
end

Tokenize = UnfoldStrict[ConsumeOnce]

Synthesize = lambda do |ast|
  if ast.is_a?(NumericLiteral)
    ast.value.to_i
  else
    op = ast.keys.first
    root = ast[op]
    l,r = root[:left], root[:right]

    # assume op is arithmetic...
    op.apply(Synthesize[l], Synthesize[r])
  end
end

Parse = lambda do |grammar|
  Proc.new("Parse") do |string|
    Synthesize.(Recognize[grammar].(Tokenize[string], grammar.start)).to_s
  end
end

class Repl
  def self.activate!
    new.run
  end

  def run(grammar)
    while true
      begin
        print "   > "
        puts Parse[grammar].(string)
      rescue => ex
        puts ex.message
        puts ex.backtrace
        "Sorry, but I could not parse '#{string}' (#{ex.message})"
      end
    end
  end
end

Repl.activate! if __FILE__==$0
