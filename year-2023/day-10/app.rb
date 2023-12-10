input_path = ARGV[0] || 'example'

@lines = File.open(input_path).map(&:strip).map(&:chars).map{|l| l.map(&:to_sym)}.to_a

s = []
@lines.each_with_index{|line, y| line.each_with_index{|ch,x| s = [y,x] if ch == :S } }

def next_steps(y, x)
  case @lines.dig(y,x)
  when nil then []
  when '.'.to_sym then []
  when :S then [[y + 1, x], [y - 1, x], [y, x-1], [y, x+1]].filter{|next_p| next_steps(*next_p).include?([y,x]) }
  when :| then [[y + 1, x], [y - 1, x]]
  when :- then [[y, x+1], [y, x-1]]
  when :L then [[y-1, x], [y, x+1]]
  when :J then [[y-1, x], [y, x-1]]
  when '7'.to_sym then [[y+1, x], [y, x-1]]
  when :F then [[y+1, x], [y, x+1]]
  end
end

vis = []
q = [s]
dists = { s => 0 }

# fix S
@lines[s[0]][s[1]] = :L         if next_steps(s[0] - 1, s[1]).include?(s) && next_steps(s[0] - 1, s[1]).include?(s)
@lines[s[0]][s[1]] = :J         if next_steps(s[0], s[1] - 1).include?(s) && next_steps(s[0] - 1, s[1]).include?(s)
@lines[s[0]][s[1]] = '7'.to_sym if next_steps(s[0], s[1] - 1).include?(s) && next_steps(s[0] + 1, s[1]).include?(s)
@lines[s[0]][s[1]] = :F         if next_steps(s[0], s[1] + 1).include?(s) && next_steps(s[0] + 1, s[1]).include?(s)
@lines[s[0]][s[1]] = :-         if next_steps(s[0], s[1] - 1).include?(s) && next_steps(s[0], s[1] + 1).include?(s)
@lines[s[0]][s[1]] = :|         if next_steps(s[0] - 1, s[1]).include?(s) && next_steps(s[0] + 1, s[1]).include?(s)

iters = 0
loop do
  break if q.empty?
  curr = q.shift

  y, x = curr

  next if vis.include? curr
  vis.push curr

  nexts = next_steps(y,x).filter{|p| @lines.dig(*p)}
  nexts.each{|p| dists[p] ||= dists[curr] + 1 }

  q.push *nexts
end
puts dists.values.max

sum = 0
@lines.each_with_index do |line, y|
  xings = 0
  bound_entry = ''
  line.each_with_index do |ch, x|
    if !vis.include?([y, x])
      sum += 1 if xings % 2 == 1
      next
    end

    bound_entry = ch if ch == :L || ch == :F
    xings += 1 if ch == :|
    xings += 1 if bound_entry == :L && ch == '7'.to_sym
    xings += 1 if bound_entry == :F && ch == :J
  end
end
puts sum
