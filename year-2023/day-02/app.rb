is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
input_path = is_test ? "input-test" : "input"

@sum = 0
@sum2 = 0

@maxes = {
  "red" => 12,
  "green" => 13,
  "blue" => 14,
}

File.open(input_path).each do |line|
  if line.strip.empty?
    next
  end

  raw_game_id, raw_all_games = line.split(':')
  game_id = raw_game_id[('Game '.length - 1)..-1].to_i

  mins = @maxes.transform_values{|color| 0}
  legal = true
  raw_games = raw_all_games.split(';').map(&:strip)
  raw_games.each do |raw_game|
    raw_game.split(',').map(&:strip).each do |raw_segment|
      raw_num, color = raw_segment.split(' ')
      num = raw_num.to_i
      legal = false if num > @maxes[color]
      mins[color] = [mins[color], num].max
    end
  end
  @sum += game_id if legal
  @sum2 += mins.values.reduce(:*)
end

puts "Sum: #{@sum}"
puts "Sum2: #{@sum2}"
