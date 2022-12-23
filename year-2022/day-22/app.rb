require 'json'

Expr = Struct.new :op, :left, :right

def part1(map, directions)
  vec_idx = 1
  c_y = 0
  c_x = map[c_y].find_index('.')
  directions.each do |d|
    vec_idx = (vec_idx + (d[:turn] == 'L' ? -1 : 1)) % 4
    d[:steps].times do
      if vec_idx == 0
        n_x = c_x + 1
        n_x = map[c_y].find_index{|ch| ch=='.'||ch=='#'} if n_x >= map[c_y].count || map[c_y][n_x] == ' ' || map[c_y][n_x] == nil
        break if map[c_y][n_x] == '#'
        c_x = n_x
      elsif vec_idx == 1
        n_y = c_y + 1
        n_y = map.find_index{|line| line[c_x]=='.'||line[c_x]=='#'} if n_y >= map.count || map[n_y][c_x] == ' ' || map[n_y][c_x] == nil
        break if map[n_y][c_x] == '#'
        c_y = n_y
      elsif vec_idx == 2
        n_x = c_x - 1
        n_x = (map[c_y].count - 1 - map[c_y].reverse.find_index{|ch| ch=='.'||ch=='#'}) if n_x < 0 || map[c_y][n_x] == ' ' || map[c_y][n_x] == nil
        break if map[c_y][n_x] == '#'
        c_x = n_x
      elsif vec_idx == 3
        n_y = c_y - 1
        n_y = (map.count - 1 - map.reverse.find_index{|line| line[c_x]=='.'||line[c_x]=='#'}) if n_y < 0 || map[n_y][c_x] == ' ' || map[n_y][c_x] == nil
        break if map[n_y][c_x] == '#'
        c_y = n_y
      else
        raise "wrong"
      end
    end
  end
  puts 1000 * (c_y+1) + 4 * (c_x+1) + vec_idx
end

def part2(map, directions)
  vec_idx = 1
  c_y = 0
  c_x = map[c_y].find_index('.')
  directions.each do |d|
    vec_idx = (vec_idx + (d[:turn] == 'L' ? -1 : 1)) % 4
    d[:steps].times do
      if vec_idx == 0
        n_x = c_x + 1
        n_y = c_y
        n_vec_idx = vec_idx
        n_x, n_y, n_vec_idx = 99, 149 - n_y, 2 if n_x >= 150 && c_y >= 0 && c_y < 50
        n_x, n_y, n_vec_idx = 100 + (c_y - 50), 49, 3 if n_x >= 100 && c_y >= 50 && c_y < 100
        n_x, n_y, n_vec_idx = 149, 149 - n_y, 2 if n_x >= 100 && c_y >= 100 && c_y < 150
        n_x, n_y, n_vec_idx = 50 + (n_y - 150), 149, 3 if n_x >= 50 && c_y >= 150 && c_y < 200
      elsif vec_idx == 1
        n_x = c_x
        n_y = c_y + 1
        n_vec_idx = vec_idx
        n_x, n_y, n_vec_idx = 149 - (49 - n_x), 0, 1 if n_x >= 0 && n_x < 50 && n_y >= 200
        n_x, n_y, n_vec_idx = 49, 150 + (n_x - 50), 2 if n_x >= 50 && n_x < 100 && n_y >= 150
        n_x, n_y, n_vec_idx = 99, 50 + (n_x - 100), 2 if n_x >= 100 && n_x < 150 && n_y >= 50
      elsif vec_idx == 2
        n_x = c_x - 1
        n_y = c_y
        n_vec_idx = vec_idx
        n_x, n_y, n_vec_idx = 0, 100 + (49 - n_y), 0 if n_x <= 49 && c_y >= 0 && c_y < 50
        n_x, n_y, n_vec_idx = n_y - 50, 100, 1 if n_x <= 49 && c_y >= 50 && c_y < 100
        n_x, n_y, n_vec_idx = 50, 50 - (n_y - 99), 0 if n_x <= -1 && c_y >= 100 && c_y < 150
        n_x, n_y, n_vec_idx = 50 + (n_y - 150), 0, 1 if n_x <= -1 && c_y >= 150 && c_y < 200
      elsif vec_idx == 3
        n_x = c_x
        n_y = c_y - 1
        n_vec_idx = vec_idx
        n_x, n_y, n_vec_idx = 50, 50 + n_x, 0 if n_x >= 0 && n_x < 50 && n_y < 100
        n_x, n_y, n_vec_idx = 0, 150 + (n_x - 50), 0 if n_x >= 50 && n_x < 100 && n_y < 0
        n_x, n_y, n_vec_idx = n_x - 100, 199, 3 if n_x >= 100 && n_x < 150 && n_y < 0
      else
        raise "wrong"
      end

      break if map[n_y][n_x] == '#'
      c_x, c_y, vec_idx = n_x, n_y, n_vec_idx
    end
  end
  puts 1000 * (c_y+1) + 4 * (c_x+1) + vec_idx
end

def run

  code = nil

  map = File.open(ARGV[0]).map do |line|
    next if line.strip.empty?
    if line.strip.match(/[RL0-9]+/)
      code = line.strip
      next
    end
    line.tr("\n", '').chars
  end.compact

  directions = []
  turn = 'L'
  steps = ''
  (code  + "\n").chars.each{|ch|
    if ch == 'L' || ch == 'R' || ch == "\n"
      directions.push({turn: turn, steps: steps.to_i})
      steps = ''
      turn = ch
    elsif ch.match(/[0-9]/)
      steps = steps + ch
    else
      raise "wrong"
    end
  }

  part1 map, directions
  part2 map, directions

end

run
