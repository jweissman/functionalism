# require 'functionalism'
# include Functionalism

class Repl
  def activate!
    puts "repl"
    while true
      print "   > "
      expr = gets
      tokens = tokenize(expr)
      ast = parse(tokens)
      result = reduce(ast)
      puts "    #{result}"
    end
  end
end

Repl.new.activate! if __FILE__==$0
