require 'Set'

Point = Struct.new(:y, :x, :ch, :conns, :froms) do
  def height; if ch == 'S' then 0 elsif ch == 'E' then 25 else ch.ord - 'a'.ord end; end
  def connect(point2)
    if point2.height <= height + 1
      conns.push point2
      point2.froms.push self
    end

    if self.height <= point2.height + 1
      point2.conns.push self
      self.froms.push point2
    end
  end
end

def run
  input_path = ARGV[0]

  map = []
  points = []
  start_point = nil
  end_point = nil

  File.open(input_path).each do |line|
    map.push line.strip.chars
  end

  map.each_with_index do |line, y|
    points[y] = []
    line.each_with_index do |ch, x|
      point = Point.new y, x, ch, [], []
      points[y][x] = point

      start_point = point if ch == 'S'
      end_point = point if ch == 'E'

      points[y][x - 1].connect(point) if x > 0
      points[y - 1][x].connect(point) if y > 0
    end
  end

  bfs = -> (start, test, go_up) {
    black = Set.new
    q = [[start]]
    min_path_count = while !q.empty?
      path = q.shift
      next_point = path.last

      break path if test.call(next_point)

      next if black.include? next_point
      black.add next_point

      candidates = go_up ? next_point.conns : next_point.froms
      candidates.each{|conn| q.push(path + [conn]) unless black.include? conn }
    end
  }

  puts bfs.call(start_point, -> (p) {p == end_point}, true).count - 1
  puts bfs.call(end_point, -> (p) {p.height == 0}, false).count - 1
end

run
