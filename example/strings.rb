require 'functionalism'
include Functionalism

class StringRewriter
  def rules
    @rules ||= [
      substitute( 'aa', 'bac' ),
      substitute( /c[a-c]/, 'c' ),
      substitute( /b[a-c]/, 'b' ),
    ]
  end

  def apply(s)
    Iterate[Compose[rules],s]
  end

  def resolve(s)
    FixedPoint[Compose[rules],s]
  end

  protected
  def substitute(x,y)
    ->(s) { s.gsub(x,y) }
  end
end

if __FILE__ == $0
  rewriter = StringRewriter.new
  strings = %w[ abc abac abacca cab caba bacbac abacac cababcabca ]
  strings.each do |string|
    puts "#{string} => #{rewriter.resolve(string)}"
  end
end
