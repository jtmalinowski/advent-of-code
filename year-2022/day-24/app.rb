require 'json'
require 'Set'

Bliz = Struct.new :x, :y, :direction, :cycle_x, :cycle_y do
  def coords_at_round(idx)
    if direction == '>'
      {y:y, x:(x+idx-1)%cycle_x+1}
    elsif direction == '<'
      {y:y, x:(x-idx-1)%cycle_x+1}
    elsif direction == '^'
      {y:(y-idx-1)%cycle_y+1, x:x}
    elsif direction == 'v'
      {y:(y+idx-1)%cycle_y+1, x:x}
    else
      raise "malformed #{direction}"
    end
  end
end

def run

  map = File.open(ARGV[0]).map do |line|
    next if line.strip.empty?
    line.tr("\n", '').chars
  end.compact

  by_coords = {}
  start = nil
  stop = nil
  blizs = []
  cycle_x = map[0].count - 2
  cycle_y = map.count - 2

  map.each_with_index do |line,y|
    line.each_with_index do |ch,x|
      coords = {x:x,y:y}
      if ch == '#'
        by_coords[coords] = :wall
        next
      end

      by_coords[coords] = :empty
      start = coords if y == 0 && ch == '.'
      stop = coords if y == map.count - 1 && ch == '.'

      if ['<', '>', '^', 'v'].include? ch
        blizs.push Bliz.new(x, y, ch, cycle_x, cycle_y)
      end
    end
  end

  dests = [{x:0,y:0},{x:1,y:0},{x:0,y:1},{x:-1,y:0},{x:0,y:-1}]

  run = -> (rnd, from, to) {
    states = Set.new
    states.add from

    part1 = catch(:part1) do
      loop do
        taken = blizs.map{|b| b.coords_at_round(rnd)}.to_set
  
        candidates = states.flat_map{ |s|
          dests.map{ |d| {x:s[:x]+d[:x],y:s[:y]+d[:y]} }.filter{|crds| by_coords[crds] == :empty }
        }.to_set
  
        possibles = candidates - taken
  
        return rnd if possibles.member?(to)
  
        states = possibles
        rnd += 1
      end
    end
  }

  leg1 = run.call(1, start, stop)
  puts leg1

  leg2 = run.call(leg1 + 1, stop, start)
  leg3 = run.call(leg2 + 1, start, stop)
  puts leg3

end

run if __FILE__ == $0
