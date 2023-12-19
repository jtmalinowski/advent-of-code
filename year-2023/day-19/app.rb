cmds = File.open(ARGV[0] || 'input-test')

workflows = {}
sum = 0

ranges = []
points = []

cmds = cmds.map do |cmd|
  cmd = cmd.strip
  next if cmd.empty?

  if match = cmd.match(/([a-z]+)\{([a-zA-Z0-9\,\:\<\>]+)\}/)
    label = match.captures[0]
    workflows[label] = match.captures[1].split(',').map do |rule|
      if rule == 'A' then { op: '*', target: 'A' }
      elsif rule == 'R' then { op: '*', target: 'R' }
      elsif m = rule.match(/^[a-zA-Z]+$/) then { op: '*', target: rule }
      elsif m = rule.match(/([xmas])([\>\<])(\d+)\:([a-zA-Z]+)/)
        key, op, threshold, target = m.captures
        {key: key.to_sym, op: op, threshold: threshold.to_i, target: target}
      else
        raise "malformed rule #{rule}"
      end
    end
  end

  if match = cmd.match(/^\{.*\}$/)
    point = eval cmd.gsub!('=', ':')
    points.push point
  end
end

def process(workflows, point)
  bind = binding
  point.keys.each{|k| bind.local_variable_set(k.to_s, point[k]) }

  workflow_id = 'in'
  rule_idx = 0

  loop do
    rule = workflows.dig(workflow_id, rule_idx)
    raise "unknown rule #{workflow_id} #{rule_idx}" unless rule

    match = case rule[:op]
    when '*' then true
    when '<' then point[rule[:key]] < rule[:threshold]
    when '>' then point[rule[:key]] > rule[:threshold]
    end

    next rule_idx += 1 unless match

    return point.values.reduce(:+) if rule[:target] == 'A'
    return 0 if rule[:target] == 'R'  

    workflow_id = rule[:target]
    rule_idx = 0
  end
end
puts points.map{|p| process workflows, p}.reduce(:+)

def process_ranges(workflows)
  sum = 0

  q = []
  q.push([{x_min: 1, x_max: 4000, m_min: 1, m_max: 4000, a_min: 1, a_max: 4000, s_min: 1, s_max: 4000}, 'in', 0])

  loop do
    break if q.empty?
    range, workflow_id, rule_idx = q.pop

    if workflow_id == 'A'
      sum += %w[x m a s].map{|l| range["#{l}_max".to_sym] - range["#{l}_min".to_sym] + 1 }.reduce(:*)
      next
    end
    next if workflow_id == 'R'

    rule = workflows.dig(workflow_id, rule_idx)
    raise "unknown rule #{workflow_id} #{rule_idx}" unless rule

    if rule[:op] == '*'
      next q.push([range, rule[:target], 0])
    end

    key_min = "#{rule[:key]}_min".to_sym
    key_max = "#{rule[:key]}_max".to_sym

    val_min = range[key_min]
    val_max = range[key_max]
    threshold = rule[:threshold]

    if rule[:op] == '<'
      next q.push([range, workflow_id, rule_idx + 1]) if val_min >= threshold
      next q.push([range, rule[:target], 0]) if val_max < threshold

      q.push [range.merge({ key_min => val_min, key_max => threshold - 1}), rule[:target], 0]
      q.push [range.merge({ key_min => threshold, key_max => val_max}), workflow_id, rule_idx + 1]
      next
    end

    if rule[:op] == '>'
      next q.push([range, workflow_id, rule_idx + 1]) if val_max <= threshold
      next q.push([range, rule[:target], 0]) if val_min > threshold

      q.push [range.merge({ key_min => val_min, key_max => threshold}), workflow_id, rule_idx + 1]
      q.push [range.merge({ key_min => threshold + 1, key_max => val_max}), rule[:target], 0]
      next
    end

    raise "unexpected"
  end

  return sum
end
puts process_ranges(workflows)
