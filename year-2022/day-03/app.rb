is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
input_path = is_test ? "input-test" : "input"

worthiness = {}
('a'..'z').each_with_index { |c,idx| worthiness[c] = 1 + idx }
('A'..'Z').each_with_index { |c,idx| worthiness[c] = 27 + idx }

sum = 0
sum3 = 0
group_of_3 = []

get_common = -> (*lines) {
  return [] unless lines.count > 1

  chars = lines
    .map { |line| line.split('') }
    .map { |line| line.reduce(Hash.new{0}){ |memo, c| memo[c] = memo[c] + 1; memo } }
  chars[0].keys.filter{|k| chars[1..-1].all?{|nth_chars| nth_chars[k] > 0}}
}

File.open(input_path).each do |line|
  value = line.strip
  next if value.empty?
  raise "wrong line length" unless value.length.even?

  p1 = value[0...(value.length / 2)]
  p2 = value[(value.length / 2)..-1]
  common = get_common.call p1, p2
  raise "invalid common" if common.count != 1
  sum += worthiness[common[0]]

  group_of_3.push value
  if group_of_3.count == 3
    common3 = get_common.call *group_of_3
    raise "invalid common" if common3.count != 1
    sum3 += worthiness[common3[0]]
    group_of_3 = []
  end
end

puts sum
puts sum3
