require 'functionalism'
include Functionalism

class Token
  def initialize(value=nil)
    @value = value
  end

  def inspect; @value end

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

class Grammar
  def rules; raise "Override Grammar#rules in #{self.class.name}" end
  def start; raise "Override Grammar#start in #{self.class.name}" end

  def recognize(tokens, key=start)
    if rules[key].is_a?(Class)
      fst = tokens.first
      if fst.is_a?(rules[key])
        return fst 
      else
        return false
      end
    end

    rules[key].each do |elements|
      if !(elements.is_a?(Array)) && (rec=recognize(tokens, elements))
        return rec
      elsif rules[elements[0]].is_a?(Class) && rules[elements[2]].is_a?(Class)
        left_to_find = rules[elements[0]]
        middle_to_find = elements[1]
        right_to_find = rules[elements[2]]

        left,right = tokens.first, tokens.last
        next unless left.is_a?(left_to_find) && right.is_a?(right_to_find)

        middle_expr = recognize(tokens[1..-2], middle_to_find)
        raise "Invalid inner expression #{middle_to_find} in #{tokens[1..-2]}" unless middle_expr

        p [ :recognize, key, tokens ]

        # it's known to be a subexpression, so we don't even need to extend the tree...
        # could be other things at some point but...
        return middle_expr

      elsif rules[elements[1]].is_a?(Class)
        left_to_find = elements[0]
        op_to_find = rules[elements[1]] # we want the class
        right_to_find = elements[2]

        i = tokens.rindex { |o| o.is_a?(op_to_find) }
        next unless i && i > 0

        found_op = tokens[i]
        left,right = tokens.take(i), tokens.drop(i+1)

        left_rec = recognize(left, left_to_find)
        right_rec = recognize(right, right_to_find)

        next unless left_rec && right_rec

        p [ :recognize, key, tokens ]
        return { found_op => { left:  left_rec, right: right_rec }}
      end
    end

    return false
  end
end

# This grammar implements the following arithmetic behaviors:
#
# expr   -> expr + term | expr - term | term
# term   -> term * factor | term / factor | factor
# factor -> digits | (expr)
#
class ArithmeticGrammar < Grammar
  def start; :expr end

  def rules
    {
      :expr   => [ %i[ expr plus term ], %i[ expr minus term ], :term ],
      :term   => [ %i[ term times factor ], %i[ term div factor ], :factor ],
      :factor => [ :digits, %i[ left_parens expr right_parens ]],

      :plus   => AdditionOperator,
      :minus  => SubtractionOperator,
      :times  => MultiplicationOperator,
      :div    => DivisionOperator,
      :digits => NumericLiteral,
      :left_parens => LeftParenthesis,
      :right_parens => RightParenthesis
    }
  end
end


class Parser
  def evaluate(expr)
    grammar = ArithmeticGrammar.new
    tokens = tokenize(expr)
    p [ :evaluate, tokens: tokens ]
    expression = grammar.recognize(tokens)
    p [ :evaluate, expression: expression ]
    reduce(expression).to_s
  end

  protected
  def reduce(ast)
    return nil if ast.nil?
    return ast.value.to_i if ast.is_a?(NumericLiteral)

    p [:reduce, ast]

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
