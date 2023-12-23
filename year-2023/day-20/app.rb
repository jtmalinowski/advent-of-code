cmds = File.open(ARGV[0] || 'input-test')

workflows = {}
sum = 0

broadcaster = []
nodes = {}

flip_states = {}
conj_states = {}

cmds = cmds.map do |cmd|
  cmd = cmd.strip
  next if cmd.empty?

  if match = cmd.match(/broadcaster -> ([a-z\, ]+)$/)
    broadcaster = match.captures[0].split(',').map(&:strip)
  end

  if match = cmd.match(/\%([a-z]+) -> ([a-z\, ]+)$/)
    label = match.captures[0]
    nodes[label] = { label: label, type: :flip, targets: match.captures[1].split(',').map(&:strip) }
    flip_states[label] = :off
  end

  if match = cmd.match(/\&([a-z]+) -> ([a-z\, ]+)$/)
    label = match.captures[0]
    nodes[label] = { label: label, type: :conj, targets: match.captures[1].split(',').map(&:strip) }
    flip_states[label] = {}
  end
end

# broadcaster not included
nodes.keys.filter{|n| nodes[n][:type] == :conj}.each do |label|
  conj_states[label] = {}
  nodes.keys.filter{|n| nodes[n][:targets].include? label }.each{|input_key| conj_states[label][input_key] = :low }
end

# puts broadcaster.inspect
# puts nodes.inspect
# puts conj_states.inspect

low_count = 0
high_count = 0
rx_found = false

last_conj = nodes.values.find{|n| n[:targets].include? 'rx' }
second_last_conjs = nodes.values.filter{|n| n[:targets].include? last_conj[:label] }.map{|n| n[:label]}
puts second_last_conjs.inspect

cycle_starts = {}
cycles = {}

(1..).each do |no|

  # puts no if no % 1000 == 0

  low_count += 1 # button
  signals = broadcaster.map{|s| [s, :low, 'broadcaster']}
  loop do
    break if signals.empty?
    curr_label, level, source_label = signals.shift
    low_count += 1 if level == :low
    high_count += 1 if level == :high
    # puts "#{source_label} (#{level})-> #{curr_label}"

    if curr_label == 'rx' && level == :low
      puts no
      rx_found = true
    end

    curr = nodes[curr_label]
    next unless curr

    if curr[:type] == :flip
      next if level == :high
      
      new_state = flip_states[curr_label] == :on ? :off : :on
      flip_states[curr_label] = flip_states[curr_label] == :on ? :off : :on

      new_signal = new_state == :on ? :high : :low
      curr[:targets].each{|t| signals.push([t, new_signal, curr_label])}

      next
    end

    if curr[:type] == :conj
      state = conj_states[curr_label]
      state[source_label] = level
      # puts conj_states.inspect

      new_signal = state.values.all?{|v| v == :high} ? :low : :high
      curr[:targets].each{|t| signals.push([t, new_signal, curr_label])}

      if second_last_conjs.include?(curr[:label]) && new_signal == :high
        puts "#{curr_label} #{no}"
        if cycle_starts[curr[:label]]
          cycles[curr[:label]] = no - cycle_starts[curr[:label]] 
        else
          cycle_starts[curr[:label]] = no
        end
      end

      next
    end
  end

  if no == 1000
    puts low_count
    puts high_count
    puts low_count * high_count
  end

  break if cycles.length == second_last_conjs.length
end

puts cycles.values.reduce(:lcm)
