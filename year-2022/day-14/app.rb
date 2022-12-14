require 'json'

Integer.class_eval do
  def to_unit
    return 1 if self > 0
    return -1 if self < 0
    self
  end
end

def run

  max_block_y = -999
  filled = []
  fill = -> (x, y) {
    filled[y] ||= []
    filled[y][x] = true
  }
  is_empty = -> (x, y) {
    return false if y >= max_block_y + 2
    !filled.dig(y, x)
  }

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?

    points = line.split('->').map(&:strip).map{|p| p.split(',').map(&:to_i)}
    (1...points.length).each do |idx|
      max_block_y = points[idx][1] > max_block_y ? points[idx][1] : max_block_y
      step_x = (points[idx][0] - points[idx - 1][0]).to_unit
      step_y = (points[idx][1] - points[idx - 1][1]).to_unit

      current = [points[idx-1][0], points[idx-1][1]]
      loop do
        fill.call(current[0], current[1])

        break if current == points[idx]
        current[0] += step_x
        current[1] += step_y
      end
    end
  end

  counter = 0
  part_1_done = false
  catch(:global_iter) do
    loop do
      current = [500, 0]
      catch(:single_iter) do
        loop do
          c_x, c_y = current[0], current[1]
          throw :global_iter if !is_empty.call(c_x, c_y)

          if c_y > max_block_y && !part_1_done
            puts counter
            part_1_done = true
          end

          if is_empty.call(c_x, c_y + 1)
            current[1] += 1
          elsif is_empty.call(c_x - 1, c_y + 1)
            current[1] += 1
            current[0] -= 1
          elsif is_empty.call(c_x + 1, c_y + 1)
            current[1] += 1
            current[0] += 1
          else
            fill.call(c_x, c_y)
            counter += 1
            throw :single_iter
          end
        end
      end
    end
  end
  puts counter
end

run
