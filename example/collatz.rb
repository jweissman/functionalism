Collatz = lambda do |n|
  return [1] if n == 1
  if n.even?
    Cons[Collatz[n/2], n]
  elsif n.odd?
    Cons[Collatz[1+(n*3)], n]
  end
end

Hailstones = Map[Collatz]
