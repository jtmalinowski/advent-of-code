input_path = ARGV[0]

sum = 0
sum2 = 0

File.open(input_path).each do |line|
  value = line.strip
  next if value.empty?

  match = value.match /(\d+)-(\d+),(\d+)-(\d+)/
  raise "wrong match for #{value}" unless match&.captures&.count == 4

  range_1_start, range_1_end, range_2_start, range_2_end = match.captures.map(&:to_i)

  if range_1_start >= range_2_start && range_1_end <= range_2_end
    sum += 1
  elsif range_1_start <= range_2_start && range_1_end >= range_2_end
    sum += 1
  end

  sum2 += 1 if [range_1_end, range_2_end].min - [range_1_start, range_2_start].max >= 0
end

puts sum
puts sum2
