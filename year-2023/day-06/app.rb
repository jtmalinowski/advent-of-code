input_path = ARGV[0] || 'example'

times = []
distances = []

lines = File.open(input_path).to_a
lines.each_with_index do |line, idx|
  line = line.strip

  if (line.start_with? "Time:")
    times = line[('Time:'.length)..-1].split(' ').map(&:strip).map(&:to_i)
    next
  end

  if (line.start_with? "Distance:")
    distances = line[('Distance:'.length)..-1].split(' ').map(&:strip).map(&:to_i)
    next
  end
end

def time_race(_time, dist)
  lo = (1..(_time - 1)).find{|w| (_time - w) * w > dist }
  hi = (_time - 1).downto(1).find{|w| (_time - w) * w > dist }
  return hi - lo + 1
end

sum = 1
times.zip(distances).each do |pair|
  _time, dist = pair
  sum *= time_race _time, dist
end

puts sum
puts time_race(times.map(&:to_s).join('').to_i, distances.map(&:to_s).join('').to_i)
