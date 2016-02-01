require 'functionalism'
include Functionalism

class Token
  def initialize(value=nil)
    @value = value
  end

  def to_s; @value end

  def self.find(chars)
    if matches?(chars.first)
      token = new(chars.take_while(&method(:matches?)).join)
      [ token, chars.drop_while(&method(:matches?)).join ]
    else
      false
    end
  end

  def self.matches?(*)
    raise "Override Token.matches? in subclass"
  end
end

class NumericLiteral < Token
  attr_reader :value

  def self.matches?(ch)
    ch.match(/[0-9]/)
  end
end

class ArithmeticOperator < Token
  def apply(a,b)
    raise "Override ArithmeticOperator#apply in subclass"
  end
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

TokenList = [ NumericLiteral, AdditionOperator, SubtractionOperator, MultiplicationOperator, DivisionOperator ]

class Grammar
  def recognize_expression(tokens)
    recognize(start, tokens)
  end

  def recognize(key, tokens)
    if rules[key].is_a?(Class)
      fst = tokens.first
      return fst if fst.is_a?(rules[key])
    else # must be a composite thing...
      rules[key].each do |elements|
        return recognize(elements,tokens) if !(elements.is_a?(Array)) && recognize(elements, tokens)

        # need to find operator -- we know by inspection there have to be three keys here
        left_to_find = elements[0]
        op_to_find = rules[elements[1]] # we want the class
        right_to_find = elements[2]

        i = tokens.rindex { |o| o.is_a?(op_to_find) }
        next unless i && i > 0

        found_op = tokens[i]
        left,right = tokens.take(i), tokens.drop(i+1)

        next unless recognize(right_to_find, right) && recognize(left_to_find, left)

        result = { found_op => { left: recognize(left_to_find, left), right: recognize(right_to_find, right) }}
        return result
      end
    end

    return false
  end
end

# This grammar implements the following arithmetic behaviors:
#
# expr   -> expr + term | expr - term | term
# term   -> term * factor | term / factor | factor
# factor -> digits [ | (expr) ]
#
class ArithmeticGrammar < Grammar
  def start; :expr end

  def rules
    {
      :expr => [ [:expr, :plus, :term], [:expr, :minus, :term], :term ],
      :term => [ [:term, :times, :factor], [:term, :div, :factor], :factor ],
      :factor => [ :digits ],

      :plus => AdditionOperator,
      :minus => SubtractionOperator,
      :times => MultiplicationOperator,
      :div => DivisionOperator,
      :digits => NumericLiteral
    }
  end
end


class Parser
  def evaluate(expr)
    grammar = ArithmeticGrammar.new
    tokens = tokenize(expr)
    expression = grammar.recognize_expression(tokens)
    reduce(expression).to_s
  end

  protected
  def reduce(ast)
    return ast.value.to_i if ast.is_a?(NumericLiteral)

    op = ast.keys.first
    root = ast[op]
    l,r = root[:left], root[:right]

    # assume op is arithmetic...
    op.apply(reduce(l), reduce(r))
  end

  def tokenize(expr)
    tokens = []
    remaining = expr
    until (next_token, remaining = consume(remaining)).nil?
      tokens.push next_token
    end
    tokens
  end

  def consume(expr)
    return nil if expr.empty?

    result = TokenList.
      map { |token_kind| token_kind.find(expr.chars) }.
      detect { |t| !!t } # first non-false (we found a token)

    result
  end
end

class Repl
  def activate!
    puts "repl"
    while true
      print "   > "
      expr = gets.chomp
      result = parser.evaluate(expr)
      puts "    #{result}"
    end
  end

  def parser
    @parser ||= Parser.new
  end
end

Repl.new.activate! if __FILE__==$0
