def run()
  sum = 0

  is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
  input_path = is_test ? "input-test" : "input"

  matches = []
  counts = []

  File.open(input_path).each_with_index do |line, idx|
    line = line.strip
    next if line.empty?

    raw_card_id, raw_winning, raw_our_nums = line.split(/[\:\|]/).map(&:strip)
    winning = raw_winning.split(' ').map(&:strip).map(&:to_i)
    our_nums = raw_our_nums.split(' ').map(&:strip).map(&:to_i)

    matches_no = winning.filter{|w| our_nums.include? w}.length
    value = case matches_no
    when 0 then 0
    when 1 then 1
    else 2.pow(matches_no - 1)
    end

    matches.push matches_no
    sum += value
  end

  counts = [1] * matches.length
  matches.each_with_index do |val, idx|
    next if val == 0
    ((idx+1)..[(idx+val),(counts.length-1)].min).each{|i| counts[i] += counts[idx]}
  end

  puts sum
  puts counts.reduce(:+)
end

run
