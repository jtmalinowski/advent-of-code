require 'debug'
input_path = ARGV[0] || 'input-test'

def palindrome_row(stack)
  (1...(stack.length)).find do |y|
    len = [y, stack.length - y].min
    stack[(y-len)...y] == stack[y...(y+len)].reverse
  end || 0
end

def count_errors(arr1, arr2)
  arr1.zip(arr2).map do |lines|
    lines.transpose.map{ |pair| pair[0] == pair[1] ? 0 : 1 }.reduce(:+)
  end.reduce(:+)
end

def relaxed_palindrome_row(stack)
  (1...(stack.length)).find do |y|
    len = [y, stack.length - y].min
    count_errors(stack[(y-len)...y], stack[y...(y+len)].reverse) == 1
  end || 0
end

sum = 0
sum2 = 0
stack = []

@lines = File.open(input_path).to_a
@lines.each_with_index do |line,idx|
  line = line.strip

  unless line.empty?
    stack.push line.chars
  end

  if line.empty? || idx == @lines.length - 1
    y = palindrome_row stack
    x = palindrome_row stack.transpose
    sum += x + y * 100

    y = relaxed_palindrome_row stack
    x = relaxed_palindrome_row stack.transpose
    sum2 += x + y * 100
    
    stack = []
  end
end
puts sum
puts sum2
