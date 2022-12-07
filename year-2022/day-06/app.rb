input_path = ARGV[0]

File.open(input_path).each do |line|
  marker_4_idx = (3...line.length).each do |idx|
    break idx + 1 if line.slice((idx - 3)..idx).chars.uniq.count == 4
  end

  marker_14_idx = (13...line.length).each do |idx|
    break idx + 1 if line.slice((idx - 13)..idx).chars.uniq.count == 14
  end

  puts "part 1: #{marker_4_idx}"
  puts "part 2: #{marker_14_idx}"
end
