is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
input_path = is_test ? "input-test" : "input"

winning_combos = { 'A' => 'Y', 'B' => 'Z', 'C' => 'X' }
drawing_combos = { 'A' => 'X', 'B' => 'Y', 'C' => 'Z' }
losing_combos = { 'A' => 'Z', 'B' => 'X', 'C' => 'Y' }
strats = { 'X' => losing_combos, 'Y' => drawing_combos, 'Z' => winning_combos }
tool_worth = { 'X' => 1, 'Y' => 2, 'Z' => 3 }

sum = 0
sum2 = 0

get_points = -> (their, mine) {
  points = tool_worth[mine]
  return points + 3 if drawing_combos[their] == mine
  return points + 6 if winning_combos[their] == mine
  return points
}

File.open(input_path).each do |line|
  codes = line.strip.split(' ')
  next if codes.count != 2

  their, mine = codes

  sum += get_points.call their, mine
  sum2 += get_points.call their, strats[mine][their]
end

puts "Part 1: #{sum}"
puts "Part 2: #{sum2}"
