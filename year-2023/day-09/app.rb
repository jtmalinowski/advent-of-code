input_path = ARGV[0] || 'example'

sum = 0
sum2 = 0

def extrapolate(nums, backwards)
  nums = nums.reverse if backwards
  diff_stack = [nums]

  loop do
    last = diff_stack[-1]
    break if last.all?{|n| n == last[0]}
    diff_stack.push last[1..-1].zip(last[0..-2]).map{|p| p[0] - p[1]}
  end

  loop do
    break if diff_stack.length == 1
    diff_stack[-2].push(diff_stack[-2][-1] + diff_stack[-1][-1])
    diff_stack.pop
  end
  diff_stack[-1][-1]
end

lines = File.open(input_path).to_a
lines.each_with_index do |line, idx|
  line = line.strip
  next if line.empty?

  nums = line.scan(/\-?\d+/).map(&:to_i)
  sum += extrapolate(nums, false)
  sum2 += extrapolate(nums, true)
end

puts sum
puts sum2
