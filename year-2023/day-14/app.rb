input_path = ARGV[0] || 'input-test'

@grid = File.open(input_path).to_a.map(&:strip).map(&:chars)

def gen_starts(direction)
  curr = case direction
  when :n then [0,0]
  when :w then [0,0]
  when :s then [@grid.length-1,0]
  when :e then [0,@grid[0].length-1]
  end

  Enumerator.new do |enum|
    loop do
      enum.yield curr.clone

      case direction
      when :n then curr[1] += 1
      when :w then curr[0] += 1
      when :s then curr[1] += 1 
      when :e then curr[0] += 1
      end
      break if curr[0] >= @grid.length || curr[1] >= @grid[0].length
    end
  end
end

def gen_inner_idxs(direction, start)
  curr = start

  Enumerator.new do |enum|
    loop do
      enum.yield curr.clone

      case direction
      when :n then curr[0] += 1
      when :w then curr[1] += 1
      when :s then curr[0] -= 1 
      when :e then curr[1] -= 1
      end

      break if curr[0] >= @grid.length
      break if curr[0] < 0
      break if curr[1] >= @grid[0].length
      break if curr[1] < 0
    end
  end
end

def sort!(direction)
  starts = gen_starts direction
  sum = 0 
  starts.each do |start|
    points = gen_inner_idxs(direction, start).to_a
    top = -1
    points.each_with_index do |point, idx|
      ch = @grid[point[0]][point[1]]
      case ch
      when '#' then top = idx
      when 'O'
        top += 1
        if top < idx
          top_pt = points[top]
          @grid[top_pt[0]][top_pt[1]] = 'O'
          @grid[point[0]][point[1]] = '.'
        end
        sum += (points.length - top)
      end
    end
  end
  return sum
end

def count(direction)
  starts = gen_starts direction
  sum = 0 
  starts.each do |start|
    points = gen_inner_idxs(direction, start).to_a
    top = -1
    points.each_with_index do |point, idx|
      ch = @grid[point[0]][point[1]]
      sum += (points.length - idx) if ch == 'O'
    end
  end
  return sum
end

vis = {}
cycle_len = 0
cycle_start = 0
counts = {}
(1..1000000000).each do |idx|
  sort!(:n)
  puts count(:n) if idx == 1

  sort!(:w)
  sort!(:s)
  sort!(:e)

  key = @grid.flatten
  if vis[key]
    cycle_len = idx - vis[key]
    cycle_start = vis[key]
    break
  end

  vis[key] = idx
  counts[idx] = count(:n)
end
counts[0] = counts[cycle_len]

puts "#{counts[((1000000000 - cycle_start) % cycle_len) + cycle_start]}"
