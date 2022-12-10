def run
  input_path = ARGV[0]

  register = 1
  cycle_idx = 0
  sums = []

  scr = []

  measure = -> (idx) { 
    sums.push (idx + 1) * register if idx + 1 == 20 || (idx + 1 - 20) % 40 == 0
  }

  draw = -> (idx) {
    idx -= 1
    screen_idx = (idx % 40)
    scr[idx] = if (register - screen_idx).abs <= 1 then '#' else '.' end
  }

  File.open(input_path).to_a.concat(["noop", "noop"]).each_with_index do |line, idx|
    if line.match /noop/
      cycle_idx += 1
      measure.call cycle_idx
      draw.call cycle_idx
    elsif (match = line.match /addx (\-?\d+)/) != nil
      op = match.captures[0].to_i
      measure.call(cycle_idx + 1)
      draw.call(cycle_idx + 1)
      cycle_idx += 2
      draw.call(cycle_idx)
      register += op
      measure.call cycle_idx
    end
  end

  puts sums.sum
  puts scr.to_a.each_slice(40).map{|s| s.join('')}.join("\n")
end

run
