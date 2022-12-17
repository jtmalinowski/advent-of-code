require 'json'
require 'Set'

Valve = Struct.new(:id, :rate, :tunnel_ids)

LINE = [{ x: 0, y: 0 }, { x: 1, y: 0 }, { x: 2, y: 0 }, { x: 3, y: 0 }]
PLUS = [{ x: 1, y: 0 }, { x: 0, y: 1 }, { x: 1, y: 1 }, { x: 2, y: 1 }, { x: 1, y: 2 }]
L = [{ x: 0, y: 0 }, { x: 1, y: 0 }, { x: 2, y: 0 }, { x: 2, y: 1 }, { x: 2, y: 2 }]
VERT = [{ x: 0, y: 0 }, { x: 0, y: 1 }, { x: 0, y: 2 }, { x: 0, y: 3 }]
SQR = [{ x: 0, y: 0 }, { x: 1, y: 0 }, { x: 0, y: 1 }, { x: 1, y: 1 }]
SHAPES = [LINE, PLUS, L, VERT, SQR]

def run

  well = [[]]
  bound_x = 6
  jets = []
  jets_idx = 0
  max_y_per_x = 7.times.map{0}

  drop = -> (shape) {
    max_y = max_y_per_x.max

    shape_x = 2
    shape_y = max_y + 4
    pos_shape = nil

    loop do
      direction = jets[jets_idx] == '<' ? -1 : 1
      jets_idx = (jets_idx + 1) % jets.count

      shape_x += direction
      pos_shape = shape.map{|p| { x: p[:x] + shape_x, y: p[:y] + shape_y } }

      shape_x -= 1 if pos_shape.map{|p| p[:x]}.max > bound_x
      shape_x = 0 if pos_shape.map{|p| p[:x]}.min < 0
      pos_shape = shape.map{|p| { x: p[:x] + shape_x, y: p[:y] + shape_y } }

      shape_x -= direction if pos_shape.any?{|p| well.dig(p[:y], p[:x])}

      shape_y -= 1
      pos_shape = shape.map{|p| { x: p[:x] + shape_x, y: p[:y] + shape_y } }

      if shape_y == 0 || pos_shape.any?{|p| well.dig(p[:y], p[:x])}
        shape_y += 1
        pos_shape = shape.map{|p| { x: p[:x] + shape_x, y: p[:y] + shape_y } }
        break
      end
    end

    pos_shape.each{|p|
      well[p[:y]] ||= []
      well[p[:y]][p[:x]] = 1

      max_y_per_x[p[:x]] = p[:y] > max_y_per_x[p[:x]] ? p[:y] : max_y_per_x[p[:x]]
    }
    return pos_shape
  }

  print = -> () {
    well.reverse.take(30).each do |line|
      puts 7.times.map{|i| line[i] ? '#' : '.'}.join('')
    end
  }

  print_coded = -> () {
    well.each_with_index do |line, idx|
      puts 7.times.reduce{|memo, i| memo + (line[i] ? 2.pow(i) : 0) }
    end
  }

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?
    jets = line.strip.chars
  end

  cycle = SHAPES.count * jets.count
  memo = []
  (4 * cycle).times{ |i| 
    new_shape = drop.call(SHAPES[i % SHAPES.count])
    memo[i] = well.count - 1
  }

  base_for_cycle = 2 * cycle
  found_cycle = nil
  (1...(2 * cycle)).each do |cycle_size|
    break found_cycle = cycle_size if (1..10).map{|i| memo[base_for_cycle+cycle_size+i] - memo[base_for_cycle+i] }.uniq.count == 1
  end

  get_from_cycle = -> (idx, precycle, cycle) {
    base_idx = cycle + precycle
    return puts memo[idx - 1] if idx < base_idx

    first_cycle_diff = memo[precycle - 1]
    big_cycle_diff = memo[base_idx - 1] - first_cycle_diff

    full_cycles = (idx - base_idx) / cycle
    first_cycle_modulo = (idx - base_idx) % cycle

    puts memo[base_idx - 1] + full_cycles * big_cycle_diff + memo[base_idx + first_cycle_modulo - 1] - memo[base_idx - 1]
  }

  get_from_cycle.call(2022, base_for_cycle, found_cycle)
  get_from_cycle.call(1000000000000, base_for_cycle, found_cycle)
end

run
